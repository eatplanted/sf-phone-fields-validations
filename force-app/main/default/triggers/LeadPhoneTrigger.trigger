trigger LeadPhoneTrigger on Lead (before insert, before update) {
    for (Lead ld : Trigger.new) {
        // Standardize and validate Phone
        if (String.isNotBlank(ld.Phone)) {
            ld.Phone = PhoneNumberUtil.standardizeExtension(ld.Phone);
            if (!PhoneNumberUtil.isValidFormat(ld.Phone)) {
                ld.Phone.addError('Invalid phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate MobilePhone
        if (String.isNotBlank(ld.MobilePhone)) {
            ld.MobilePhone = PhoneNumberUtil.standardizeExtension(ld.MobilePhone);
            if (!PhoneNumberUtil.isValidFormat(ld.MobilePhone)) {
                ld.MobilePhone.addError('Invalid mobile phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate Fax
        if (String.isNotBlank(ld.Fax)) {
            ld.Fax = PhoneNumberUtil.standardizeExtension(ld.Fax);
            if (!PhoneNumberUtil.isValidFormat(ld.Fax)) {
                ld.Fax.addError('Invalid fax format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }
    }
}
