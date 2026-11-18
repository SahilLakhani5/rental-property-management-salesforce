import { LightningElement, wire } from 'lwc';
import getProperties from '@salesforce/apex/RentalDashboardController.getProperties';

const COLUMNS = [
  { label: 'Property', fieldName: 'Name', type: 'text' },
  { label: 'Type', fieldName: 'Property_Type__c', type: 'text' },
  { label: 'City', fieldName: 'City__c', type: 'text' },
  { label: 'State', fieldName: 'State__c', type: 'text' },
  { label: 'Status', fieldName: 'Status__c', type: 'text' }
];

export default class PropertyList extends LightningElement {
  properties = [];
  searchKey = '';
  columns = COLUMNS;
  error;

  @wire(getProperties)
  wired({ data, error }) {
    if (data) { this.properties = data; this.error = undefined; }
    else if (error) { this.error = error; this.properties = []; }
  }

  handleSearch(event) { this.searchKey = event.target.value || ''; }

  get filteredProperties() {
    const key = this.searchKey.trim().toLowerCase();
    if (!key) return this.properties;
    return this.properties.filter(row =>
      [row.Name, row.Property_Type__c, row.City__c, row.State__c, row.Status__c]
        .some(value => (value || '').toLowerCase().includes(key))
    );
  }

  get hasRows() { return this.filteredProperties.length > 0; }
  get errorMessage() { return this.error?.body?.message || 'Unable to load properties.'; }
}
