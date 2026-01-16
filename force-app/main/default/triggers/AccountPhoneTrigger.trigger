trigger AccountPhoneTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Standardize Phone field
        if (String.isNotBlank(acc.Phone)) {
            acc.Phone = PhoneNumberUtil.standardizeExtension(acc.Phone);
        }
        
        // Standardize Fax field
        if (String.isNotBlank(acc.Fax)) {
            acc.Fax = PhoneNumberUtil.standardizeExtension(acc.Fax);
        }
    }
}
