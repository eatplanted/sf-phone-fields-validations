@isTest
private class PhoneNumberUtilTest {
    
    @isTest
    static void testStandardizeExtension_LowercaseX() {
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234x123'),
            'Lowercase x without space should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 x 123'),
            'Lowercase x with spaces should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_UppercaseX() {
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234X123'),
            'Uppercase X without space should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 X 123'),
            'Uppercase X with spaces should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_Ext() {
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234ext123'),
            'ext without space should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 ext 123'),
            'ext with spaces should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 EXT 123'),
            'EXT uppercase should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 Ext 123'),
            'Ext mixed case should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_ExtWithPeriod() {
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 Ext. 123'),
            'Ext. with period should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 EXT. 123'),
            'EXT. uppercase with period should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_Extension() {
        System.assertEquals('+1 555-1234;890', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 extension 890'),
            'extension lowercase should convert to semicolon');
        System.assertEquals('+1 555-1234;890', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 EXTENSION 890'),
            'EXTENSION uppercase should convert to semicolon');
        System.assertEquals('+1 555-1234;890', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234 Extension 890'),
            'Extension mixed case should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_Comma() {
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234,123'),
            'Comma format should convert to semicolon');
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234, 123'),
            'Comma with space should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_NoExtension() {
        System.assertEquals('+1 555-1234', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234'),
            'Phone without extension should remain unchanged');
        System.assertEquals('+41 44 123 45 67', 
            PhoneNumberUtil.standardizeExtension('+41 44 123 45 67'),
            'International number should remain unchanged');
    }
    
    @isTest
    static void testStandardizeExtension_AlreadyStandardized() {
        System.assertEquals('+1 555-1234;123', 
            PhoneNumberUtil.standardizeExtension('+1 555-1234;123'),
            'Already standardized number should remain unchanged');
    }
    
    @isTest
    static void testStandardizeExtension_Blank() {
        System.assertEquals(null, 
            PhoneNumberUtil.standardizeExtension(null),
            'Null should return null');
        System.assertEquals('', 
            PhoneNumberUtil.standardizeExtension(''),
            'Empty string should return empty string');
    }
    
    @isTest
    static void testStandardizeExtension_FormattingCleanup() {
        System.assertEquals('+1 (555) 123-4567;890', 
            PhoneNumberUtil.standardizeExtension('+1 ( 555 ) 123 - 4567 ext 890'),
            'Should clean up extra spaces in formatting');
    }
    
    @isTest
    static void testIsValidFormat_Valid() {
        System.assert(PhoneNumberUtil.isValidFormat('+1 555-1234'), 
            'Basic format should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+1 (555) 123-4567'), 
            'Format with parentheses should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 45 67'), 
            'International format should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+1 555-1234;123'), 
            'Format with extension should be valid');
        System.assert(PhoneNumberUtil.isValidFormat(null), 
            'Null should be valid');
        System.assert(PhoneNumberUtil.isValidFormat(''), 
            'Empty string should be valid');
    }
    
    @isTest
    static void testIsValidFormat_Invalid() {
        System.assert(!PhoneNumberUtil.isValidFormat('555-1234'), 
            'Missing country code should be invalid');
        System.assert(!PhoneNumberUtil.isValidFormat('+'), 
            'Just plus sign should be invalid');
        System.assert(!PhoneNumberUtil.isValidFormat('+1'), 
            'Too short should be invalid');
    }
    
    @isTest
    static void testIntegration_Account() {
        Account acc = new Account(
            Name = 'Test Company',
            Phone = '+1 555-1234x100',
            Fax = '+1 555-5678 ext 200'
        );
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        acc = [SELECT Phone, Fax FROM Account WHERE Id = :acc.Id];
        System.assertEquals('+1 555-1234;100', acc.Phone, 
            'Account Phone should be standardized');
        System.assertEquals('+1 555-5678;200', acc.Fax, 
            'Account Fax should be standardized');
    }
    
    @isTest
    static void testIntegration_Contact() {
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Phone = '+1 555-1234x123',
            MobilePhone = '+1 555-5678 Ext. 890',
            HomePhone = '+1 555-9012,456',
            OtherPhone = '+1 555-3456 extension 789',
            AssistantPhone = '+1 555-7890X111',
            Fax = '+1 555-2468 EXT 333'
        );
        
        Test.startTest();
        insert con;
        Test.stopTest();
        
        con = [SELECT Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone, Fax 
               FROM Contact WHERE Id = :con.Id];
        System.assertEquals('+1 555-1234;123', con.Phone);
        System.assertEquals('+1 555-5678;890', con.MobilePhone);
        System.assertEquals('+1 555-9012;456', con.HomePhone);
        System.assertEquals('+1 555-3456;789', con.OtherPhone);
        System.assertEquals('+1 555-7890;111', con.AssistantPhone);
        System.assertEquals('+1 555-2468;333', con.Fax);
    }
    
    @isTest
    static void testIntegration_Lead() {
        Lead ld = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Phone = '+1 555-1234x500',
            MobilePhone = '+1 555-5678 ext 600',
            Fax = '+1 555-9012,700'
        );
        
        Test.startTest();
        insert ld;
        Test.stopTest();
        
        ld = [SELECT Phone, MobilePhone, Fax FROM Lead WHERE Id = :ld.Id];
        System.assertEquals('+1 555-1234;500', ld.Phone);
        System.assertEquals('+1 555-5678;600', ld.MobilePhone);
        System.assertEquals('+1 555-9012;700', ld.Fax);
    }
    
    @isTest
    static void testIntegration_Case() {
        Case cs = new Case(
            Subject = 'Test Case',
            ContactPhone = '+1 555-1234x800',
            ContactMobile = '+1 555-5678 Ext. 900',
            ContactFax = '+1 555-9012,1000'
        );
        
        Test.startTest();
        insert cs;
        Test.stopTest();
        
        cs = [SELECT ContactPhone, ContactMobile, ContactFax FROM Case WHERE Id = :cs.Id];
        System.assertEquals('+1 555-1234;800', cs.ContactPhone);
        System.assertEquals('+1 555-5678;900', cs.ContactMobile);
        System.assertEquals('+1 555-9012;1000', cs.ContactFax);
    }
    
    @isTest
    static void testBulk_MultipleRecords() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(
                FirstName = 'Bulk',
                LastName = 'Test' + i,
                Phone = '+1 555-' + i + 'x' + i
            ));
        }
        
        Test.startTest();
        insert contacts;
        Test.stopTest();
        
        contacts = [SELECT Phone FROM Contact WHERE LastName LIKE 'Test%' ORDER BY LastName];
        System.assertEquals(200, contacts.size(), 'Should insert 200 contacts');
        
        for (Contact c : contacts) {
            System.assert(c.Phone.contains(';'), 
                'All phone numbers should be standardized with semicolon');
        }
    }
}
