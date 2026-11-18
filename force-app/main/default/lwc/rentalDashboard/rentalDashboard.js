import { LightningElement, wire } from 'lwc';
import getDashboardData from '@salesforce/apex/RentalDashboardController.getDashboardData';

export default class RentalDashboard extends LightningElement {
  data;
  error;
  isLoading = true;

  @wire(getDashboardData)
  wiredData({ data, error }) {
    this.isLoading = false;
    if (data) {
      this.data = data;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.data = undefined;
    }
  }

  get metrics() {
    if (!this.data) return [];
    return [
      { label: 'Properties', value: this.data.propertyCount },
      { label: 'Total Units', value: this.data.unitCount },
      { label: 'Active Leases', value: this.data.activeLeaseCount },
      { label: 'Open Maintenance', value: this.data.openMaintenanceCount }
    ];
  }

  get formattedRentRoll() {
    return new Intl.NumberFormat('en-US', {
      style: 'currency', currency: 'USD', maximumFractionDigits: 0
    }).format(this.data?.monthlyRentRoll || 0);
  }

  get formattedOccupancy() {
    return `${(this.data?.occupancyRate || 0).toFixed(1)}%`;
  }

  get errorMessage() {
    return this.error?.body?.message || 'Unable to load dashboard metrics.';
  }
}
