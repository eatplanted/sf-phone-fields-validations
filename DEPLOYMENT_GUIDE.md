# Phone Field Validation Rules - Deployment Guide

## Overview
This project contains validation rules for all phone-related fields across Account, Contact, Lead, and Case objects in your Salesforce org.

## Validation Rules Created

### Account (2 validation rules)
1. **Phone_Format_Validation** - Validates Account.Phone field
2. **Fax_Format_Validation** - Validates Account.Fax field

### Contact (6 validation rules)
1. **Contact_Phone_Format_Validation** - Validates Contact.Phone field
2. **Contact_MobilePhone_Format_Validation** - Validates Contact.MobilePhone field
3. **Contact_HomePhone_Format_Validation** - Validates Contact.HomePhone field
4. **Contact_OtherPhone_Format_Validation** - Validates Contact.OtherPhone field
5. **Contact_AssistantPhone_Format_Validation** - Validates Contact.AssistantPhone field
6. **Contact_Fax_Format_Validation** - Validates Contact.Fax field

### Lead (3 validation rules)
1. **Lead_Phone_Format_Validation** - Validates Lead.Phone field
2. **Lead_MobilePhone_Format_Validation** - Validates Lead.MobilePhone field
3. **Lead_Fax_Format_Validation** - Validates Lead.Fax field

### Case (3 validation rules)
1. **Case_ContactPhone_Format_Validation** - Validates Case.ContactPhone field
2. **Case_ContactMobile_Format_Validation** - Validates Case.ContactMobile field
3. **Case_ContactFax_Format_Validation** - Validates Case.ContactFax field

## Validation Logic

All validation rules enforce the following criteria:
- **Minimum length**: 7 characters
- **Maximum length**: 40 characters
- **Allowed characters**: digits (0-9), spaces, hyphens (-), parentheses (), plus signs (+), periods (.)
- **Format examples**:
  - `+1 (555) 123-4567`
  - `555-123-4567`
  - `+44 20 7123 4567`
  - `(555) 123-4567`
  - `555.123.4567`

## Deployment Steps

### Option 1: Deploy All Validation Rules to dev03
```bash
sf project deploy start --target-org dev03
```

### Option 2: Deploy Specific Objects
```bash
# Deploy Account validation rules
sf project deploy start --metadata "ValidationRule:Account.Phone_Format_Validation,ValidationRule:Account.Fax_Format_Validation" --target-org dev03

# Deploy Contact validation rules
sf project deploy start --source-dir force-app/main/default/objects/Contact/validationRules --target-org dev03

# Deploy Lead validation rules
sf project deploy start --source-dir force-app/main/default/objects/Lead/validationRules --target-org dev03

# Deploy Case validation rules
sf project deploy start --source-dir force-app/main/default/objects/Case/validationRules --target-org dev03
```

### Option 3: Deploy to Other Orgs
```bash
# Deploy to dev01
sf project deploy start --target-org dev01

# Deploy to dev02
sf project deploy start --target-org dev02

# Deploy to stage
sf project deploy start --target-org stage
```

## Testing the Validation Rules

After deployment, test each validation rule:

1. **Valid phone numbers** (should save successfully):
   - `+1 555-123-4567`
   - `(555) 123-4567`
   - `555.123.4567`
   - `+44 20 7123 4567`

2. **Invalid phone numbers** (should show validation error):
   - `123` (too short)
   - `abc-def-ghij` (contains letters)
   - `555#123#4567` (invalid character #)
   - Empty/blank values are allowed (not required)

## Deactivating Rules

If you need to temporarily disable any validation rule, you can:

1. In Salesforce UI:
   - Go to Setup → Object Manager → [Object] → Validation Rules
   - Edit the rule and uncheck "Active"

2. Via Metadata:
   - Edit the validation rule file
   - Change `<active>true</active>` to `<active>false</active>`
   - Deploy the change

## Customization

To modify the validation logic:

1. Edit the corresponding validation rule file in:
   - `force-app/main/default/objects/[Object]/validationRules/`

2. Modify the `<errorConditionFormula>` section

3. Deploy the changes:
   ```bash
   sf project deploy start --target-org dev03
   ```

## Common Customization Scenarios

### Make a phone field required:
Replace the entire formula with:
```xml
<errorConditionFormula>ISBLANK(Phone)</errorConditionFormula>
<errorMessage>Phone number is required.</errorMessage>
```

### Change minimum length to 10:
Change `LEN(Phone) &lt; 7` to `LEN(Phone) &lt; 10`

### Enforce specific format (US only):
```xml
<errorConditionFormula>AND(
    NOT(ISBLANK(Phone)),
    NOT(REGEX(Phone, "^\\(?[0-9]{3}\\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}$"))
)</errorConditionFormula>
```

## Rollback

To remove all validation rules:
```bash
sf project delete source --metadata "ValidationRule:Account.Phone_Format_Validation,ValidationRule:Account.Fax_Format_Validation" --target-org dev03
```

Or delete individual validation rules from Setup UI.

## Notes

- Validation rules run only when records are saved (create/update)
- Existing records with invalid phone numbers will not be automatically flagged
- Consider running a data quality report after deployment to identify existing invalid phone numbers
- Validation rules do not prevent bulk operations via API unless the API call respects validation rules
