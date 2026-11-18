# Rental Property Management System

A Salesforce DX portfolio application for managing rental properties, units, tenants, leases, payment tracking, and maintenance requests.

## Technology
- Salesforce DX
- Apex controllers and unit tests
- Lightning Web Components
- Custom objects and fields
- Permission sets

## Data model
- `Property__c`: property address, type, and status
- `Unit__c`: rentable unit, linked to a property
- `Tenant__c`: tenant contact information
- `Lease__c`: tenant/unit lease, dates, rent, and status
- `Payment__c`: rent payment tracking records
- `Maintenance_Request__c`: maintenance work queue linked to a unit and tenant

## UI components
- `rentalDashboard`: portfolio metrics, monthly rent roll, and occupancy
- `propertyList`: searchable property list
- `maintenanceList`: recent maintenance requests

## Deploy
Run from this project root:

```bash
sf org list
sf config set target-org=SahilDev
sf project deploy start --target-org SahilDev
```

Run tests after deployment:

```bash
sf apex run test --target-org SahilDev --test-level RunLocalTests --wait 30
```

Assign the permission set:

```bash
sf org assign permset --name Rental_Manager --target-org SahilDev
```

## Add the dashboard to Salesforce
1. Open Setup and search for Lightning App Builder.
2. Create or edit a Home Page.
3. Add Rental Dashboard, Property List, and Maintenance List components.
4. Save and activate the page.

## Notes
This is a development/portfolio application, not a production property-management or payment-processing platform. Payment records track amounts and dates only; the app does not collect card or bank credentials. Review sharing, field-level security, validation, and applicable privacy requirements before using real tenant information.
