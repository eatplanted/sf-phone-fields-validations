trigger CasePhoneTrigger on Case (before insert, before update) {
    for (Case cs : Trigger.new) {
        // Standardize all phone fields
        if (String.isNotBlank(cs.ContactPhone)) {
            cs.ContactPhone = PhoneNumberUtil.standardizeExtension(cs.ContactPhone);
        }
        
        if (String.isNotBlank(cs.ContactMobile)) {
            cs.ContactMobile = PhoneNumberUtil.standardizeExtension(cs.ContactMobile);
        }
        
        if (String.isNotBlank(cs.ContactFax)) {
            cs.ContactFax = PhoneNumberUtil.standardizeExtension(cs.ContactFax);
        }
    }
}
