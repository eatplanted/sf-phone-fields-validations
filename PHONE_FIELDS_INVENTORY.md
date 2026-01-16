# Phone Fields Inventory - dev03 Org

This document lists all phone-type fields found in the dev03 Salesforce org.

## Standard Objects

### Account
- **Phone** (Account Phone) - Standard field
- **Fax** (Account Fax) - Standard field

### Contact
- **Phone** (Business Phone) - Standard field
- **Fax** (Business Fax) - Standard field
- **MobilePhone** (Mobile Phone) - Standard field
- **HomePhone** (Home Phone) - Standard field
- **OtherPhone** (Other Phone) - Standard field
- **AssistantPhone** (Asst. Phone) - Standard field

### Lead
- **Phone** (Phone) - Standard field
- **MobilePhone** (Mobile Phone) - Standard field
- **Fax** (Fax) - Standard field

### Case
- **ContactPhone** (Contact Phone) - Standard field
- **ContactMobile** (Contact Mobile) - Standard field
- **ContactFax** (Contact Fax) - Standard field

## Total Phone Fields
- **Account**: 2 fields
- **Contact**: 6 fields
- **Lead**: 3 fields
- **Case**: 3 fields
- **Total**: 14 phone fields

## Custom Objects
No custom phone fields found in custom objects.

## Validation Strategy

To add validation rules for these phone fields, we'll create:
1. Validation rules for each object that enforce phone number format
2. Common patterns like:
   - International format: +[country code][number]
   - US format: (XXX) XXX-XXXX or XXX-XXX-XXXX
   - Allow digits, spaces, parentheses, hyphens, and plus signs
   - Minimum and maximum length requirements
