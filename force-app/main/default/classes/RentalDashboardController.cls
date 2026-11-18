public with sharing class RentalDashboardController {
    public class DashboardData {
        @AuraEnabled public Integer propertyCount { get; set; }
        @AuraEnabled public Integer unitCount { get; set; }
        @AuraEnabled public Integer occupiedUnitCount { get; set; }
        @AuraEnabled public Integer activeLeaseCount { get; set; }
        @AuraEnabled public Integer openMaintenanceCount { get; set; }
        @AuraEnabled public Decimal monthlyRentRoll { get; set; }
        @AuraEnabled public Decimal occupancyRate { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static DashboardData getDashboardData() {
        DashboardData d = new DashboardData();
        d.propertyCount = [SELECT COUNT() FROM Property__c];
        d.unitCount = [SELECT COUNT() FROM Unit__c];
        d.occupiedUnitCount = [SELECT COUNT() FROM Unit__c WHERE Status__c = 'Occupied'];
        d.activeLeaseCount = [SELECT COUNT() FROM Lease__c WHERE Status__c = 'Active'];
        d.openMaintenanceCount = [
            SELECT COUNT() FROM Maintenance_Request__c
            WHERE Status__c NOT IN ('Completed', 'Cancelled')
        ];
        AggregateResult rentResult = [
            SELECT SUM(Monthly_Rent__c) total
            FROM Lease__c WHERE Status__c = 'Active'
        ];
        d.monthlyRentRoll = (Decimal)rentResult.get('total');
        if (d.monthlyRentRoll == null) d.monthlyRentRoll = 0;
        d.occupancyRate = d.unitCount == 0 ? 0 :
            (Decimal.valueOf(d.occupiedUnitCount) / Decimal.valueOf(d.unitCount)) * 100;
        return d;
    }

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties() {
        return [
            SELECT Id, Name, Property_Type__c, City__c, State__c, Status__c
            FROM Property__c ORDER BY LastModifiedDate DESC LIMIT 200
        ];
    }


    public class MaintenanceRow {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String priority { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String unitName { get; set; }
        @AuraEnabled public String tenantName { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static List<MaintenanceRow> getRecentMaintenance() {
        List<Maintenance_Request__c> records = [
            SELECT Id, Name, Description__c, Priority__c, Status__c,
                   Unit__c, Tenant__c
            FROM Maintenance_Request__c
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];

        Set<Id> unitIds = new Set<Id>();
        Set<Id> tenantIds = new Set<Id>();

        for (Maintenance_Request__c record : records) {
            if (record.Unit__c != null) unitIds.add(record.Unit__c);
            if (record.Tenant__c != null) tenantIds.add(record.Tenant__c);
        }

        Map<Id, Unit__c> units = new Map<Id, Unit__c>();
        Map<Id, Tenant__c> tenants = new Map<Id, Tenant__c>();

        if (!unitIds.isEmpty()) {
            units = new Map<Id, Unit__c>([
                SELECT Id, Name FROM Unit__c WHERE Id IN :unitIds
            ]);
        }

        if (!tenantIds.isEmpty()) {
            tenants = new Map<Id, Tenant__c>([
                SELECT Id, Name FROM Tenant__c WHERE Id IN :tenantIds
            ]);
        }

        List<MaintenanceRow> results = new List<MaintenanceRow>();

        for (Maintenance_Request__c record : records) {
            MaintenanceRow row = new MaintenanceRow();
            row.Id = record.Id;
            row.Name = record.Name;
            row.description = record.Description__c;
            row.priority = record.Priority__c;
            row.status = record.Status__c;

            if (record.Unit__c != null && units.containsKey(record.Unit__c)) {
                row.unitName = units.get(record.Unit__c).Name;
            }

            if (record.Tenant__c != null && tenants.containsKey(record.Tenant__c)) {
                row.tenantName = tenants.get(record.Tenant__c).Name;
            }

            results.add(row);
        }

        return results;
    }

}
