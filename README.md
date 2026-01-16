# Salesforce Phone Fields Validations

This project contains Salesforce metadata for phone field validations.

## Project Structure

```
force-app/
└── main/
    └── default/
        ├── classes/
        ├── objects/
        ├── triggers/
        ├── lwc/
        └── aura/
```

## Getting Started

### Prerequisites

- Salesforce CLI installed
- VS Code with Salesforce Extensions
- A Salesforce org (Dev, Sandbox, or Scratch)

### Setup

1. Authorize your org:
   ```
   sf org login web
   ```

2. Deploy the metadata:
   ```
   sf project deploy start
   ```

3. Pull changes from org:
   ```
   sf project retrieve start
   ```

## Development

- Use `sf project deploy start` to deploy changes to your org
- Use `sf project retrieve start` to retrieve metadata from your org
- Use `sf apex run test` to run Apex tests

## Resources

- [Salesforce CLI Documentation](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
