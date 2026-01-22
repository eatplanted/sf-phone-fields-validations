trigger AccountPhoneTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Standardize and validate Phone field
        if (String.isNotBlank(acc.Phone)) {
            acc.Phone = PhoneNumberUtil.standardizeExtension(acc.Phone);
            if (!PhoneNumberUtil.isValidFormat(acc.Phone)) {
                acc.Phone.addError('Invalid phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate Fax field
        if (String.isNotBlank(acc.Fax)) {
            acc.Fax = PhoneNumberUtil.standardizeExtension(acc.Fax);
            if (!PhoneNumberUtil.isValidFormat(acc.Fax)) {
                acc.Fax.addError('Invalid fax format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }
    }
}
