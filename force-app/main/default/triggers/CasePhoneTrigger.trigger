trigger CasePhoneTrigger on Case (before insert, before update) {
    // Note: Case.ContactPhone, ContactMobile, ContactFax are read-only formula fields
    // that pull from the related Contact. Validation should happen on Contact, not Case.
    // This trigger is kept for reference but has no active logic.
}
