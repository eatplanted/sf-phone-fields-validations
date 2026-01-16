trigger ContactPhoneTrigger on Contact (before insert, before update) {
    for (Contact con : Trigger.new) {
        // Standardize all phone fields
        if (String.isNotBlank(con.Phone)) {
            con.Phone = PhoneNumberUtil.standardizeExtension(con.Phone);
        }
        
        if (String.isNotBlank(con.MobilePhone)) {
            con.MobilePhone = PhoneNumberUtil.standardizeExtension(con.MobilePhone);
        }
        
        if (String.isNotBlank(con.HomePhone)) {
            con.HomePhone = PhoneNumberUtil.standardizeExtension(con.HomePhone);
        }
        
        if (String.isNotBlank(con.OtherPhone)) {
            con.OtherPhone = PhoneNumberUtil.standardizeExtension(con.OtherPhone);
        }
        
        if (String.isNotBlank(con.AssistantPhone)) {
            con.AssistantPhone = PhoneNumberUtil.standardizeExtension(con.AssistantPhone);
        }
        
        if (String.isNotBlank(con.Fax)) {
            con.Fax = PhoneNumberUtil.standardizeExtension(con.Fax);
        }
    }
}
