trigger LeadPhoneTrigger on Lead (before insert, before update) {
    for (Lead ld : Trigger.new) {
        // Standardize all phone fields
        if (String.isNotBlank(ld.Phone)) {
            ld.Phone = PhoneNumberUtil.standardizeExtension(ld.Phone);
        }
        
        if (String.isNotBlank(ld.MobilePhone)) {
            ld.MobilePhone = PhoneNumberUtil.standardizeExtension(ld.MobilePhone);
        }
        
        if (String.isNotBlank(ld.Fax)) {
            ld.Fax = PhoneNumberUtil.standardizeExtension(ld.Fax);
        }
    }
}
