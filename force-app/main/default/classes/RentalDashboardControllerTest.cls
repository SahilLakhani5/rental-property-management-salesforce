@IsTest
private class RentalDashboardControllerTest {
    @IsTest
    static void dashboardAndListsReturnData() {
        Property__c p = new Property__c(
            Name='Test Property', Property_Type__c='Residential',
            City__c='Seattle', State__c='WA', Status__c='Active'
        );
        insert p;
        Unit__c u = new Unit__c(
            Name='Unit 101', Property__c=p.Id,
            Monthly_Rent__c=1800, Status__c='Occupied'
        );
        insert u;
        Tenant__c t = new Tenant__c(Name='Jordan Tenant', Email__c='jordan@example.com');
        insert t;
        insert new Lease__c(
            Unit__c=u.Id, Tenant__c=t.Id, Start_Date__c=Date.today(),
            End_Date__c=Date.today().addDays(365), Monthly_Rent__c=1800, Status__c='Active'
        );
        insert new Maintenance_Request__c(
            Unit__c=u.Id, Tenant__c=t.Id, Description__c='Test request',
            Priority__c='Medium', Status__c='New'
        );

        Test.startTest();
        RentalDashboardController.DashboardData d = RentalDashboardController.getDashboardData();
        List<Property__c> properties = RentalDashboardController.getProperties();
        List<RentalDashboardController.MaintenanceRow> requests = RentalDashboardController.getRecentMaintenance();
        Test.stopTest();

        System.assertEquals(1, d.propertyCount);
        System.assertEquals(1, d.unitCount);
        System.assertEquals(1, d.occupiedUnitCount);
        System.assertEquals(1, d.activeLeaseCount);
        System.assertEquals(1, d.openMaintenanceCount);
        System.assertEquals(1800, d.monthlyRentRoll);
        System.assertEquals(100, d.occupancyRate);
        System.assertEquals(1, properties.size());
        System.assertEquals(1, requests.size());
    }
}
