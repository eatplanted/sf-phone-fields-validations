trigger ContactPhoneTrigger on Contact (before insert, before update) {
    for (Contact con : Trigger.new) {
        // Standardize and validate Phone
        if (String.isNotBlank(con.Phone)) {
            con.Phone = PhoneNumberUtil.standardizeExtension(con.Phone);
            if (!PhoneNumberUtil.isValidFormat(con.Phone)) {
                con.Phone.addError('Invalid phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate MobilePhone
        if (String.isNotBlank(con.MobilePhone)) {
            con.MobilePhone = PhoneNumberUtil.standardizeExtension(con.MobilePhone);
            if (!PhoneNumberUtil.isValidFormat(con.MobilePhone)) {
                con.MobilePhone.addError('Invalid mobile phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate HomePhone
        if (String.isNotBlank(con.HomePhone)) {
            con.HomePhone = PhoneNumberUtil.standardizeExtension(con.HomePhone);
            if (!PhoneNumberUtil.isValidFormat(con.HomePhone)) {
                con.HomePhone.addError('Invalid home phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate OtherPhone
        if (String.isNotBlank(con.OtherPhone)) {
            con.OtherPhone = PhoneNumberUtil.standardizeExtension(con.OtherPhone);
            if (!PhoneNumberUtil.isValidFormat(con.OtherPhone)) {
                con.OtherPhone.addError('Invalid other phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate AssistantPhone
        if (String.isNotBlank(con.AssistantPhone)) {
            con.AssistantPhone = PhoneNumberUtil.standardizeExtension(con.AssistantPhone);
            if (!PhoneNumberUtil.isValidFormat(con.AssistantPhone)) {
                con.AssistantPhone.addError('Invalid assistant phone format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }

        // Standardize and validate Fax
        if (String.isNotBlank(con.Fax)) {
            con.Fax = PhoneNumberUtil.standardizeExtension(con.Fax);
            if (!PhoneNumberUtil.isValidFormat(con.Fax)) {
                con.Fax.addError('Invalid fax format. Must start with + followed by a valid country code, have at least 7 digits, and not be a dummy number.');
            }
        }
    }
}
