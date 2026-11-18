import { LightningElement, wire } from 'lwc';
import getRecentMaintenance from '@salesforce/apex/RentalDashboardController.getRecentMaintenance';

const COLUMNS = [
  { label: 'Request', fieldName: 'Name', type: 'text' },
  { label: 'Unit', fieldName: 'unitName', type: 'text' },
  { label: 'Tenant', fieldName: 'tenantName', type: 'text' },
  { label: 'Priority', fieldName: 'Priority__c', type: 'text' },
  { label: 'Status', fieldName: 'Status__c', type: 'text' }
];

export default class MaintenanceList extends LightningElement {
  requests = [];
  columns = COLUMNS;
  error;

  @wire(getRecentMaintenance)
  wired({ data, error }) {
    if (data) {
      this.requests = data.map(row => ({
        ...row,
        Priority__c: row.priority,
        Status__c: row.status,
        unitName: row.unitName || '',
        tenantName: row.tenantName || ''
      }));
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.requests = [];
    }
  }

  get errorMessage() { return this.error?.body?.message || 'Unable to load maintenance requests.'; }
}
