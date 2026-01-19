@isTest
private class PhoneNumberUtilTest {
    
    @isTest
    static void testStandardizeExtension_LowercaseX() {
        System.assertEquals('+41 44 123 4567;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 123 4567x123'),
            'Lowercase x without space should convert to semicolon');
        System.assertEquals('+41 44 123 4567;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 123 4567 x 123'),
            'Lowercase x with spaces should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_UppercaseX() {
        System.assertEquals('+41 44 987 6543;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 987 6543X123'),
            'Uppercase X without space should convert to semicolon');
        System.assertEquals('+41 44 987 6543;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 987 6543 X 123'),
            'Uppercase X with spaces should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_Ext() {
        System.assertEquals('+41 44 555 1234;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 555 1234ext123'),
            'ext without space should convert to semicolon');
        System.assertEquals('+41 44 555 1234;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 555 1234 ext 123'),
            'ext with spaces should convert to semicolon');
        System.assertEquals('+41 44 555 1234;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 555 1234 EXT 123'),
            'EXT uppercase should convert to semicolon');
        System.assertEquals('+41 44 555 1234;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 555 1234 Ext 123'),
            'Ext mixed case should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_ExtWithPeriod() {
        System.assertEquals('+41 79 111 2233;123', 
            PhoneNumberUtil.standardizeExtension('+41 79 111 2233 Ext. 123'),
            'Ext. with period should convert to semicolon');
        System.assertEquals('+41 79 111 2233;123', 
            PhoneNumberUtil.standardizeExtension('+41 79 111 2233 EXT. 123'),
            'EXT. uppercase with period should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_Extension() {
        System.assertEquals('+41 44 222 3344;890', 
            PhoneNumberUtil.standardizeExtension('+41 44 222 3344 extension 890'),
            'extension lowercase should convert to semicolon');
        System.assertEquals('+41 44 222 3344;890', 
            PhoneNumberUtil.standardizeExtension('+41 44 222 3344 EXTENSION 890'),
            'EXTENSION uppercase should convert to semicolon');
        System.assertEquals('+41 44 222 3344;890', 
            PhoneNumberUtil.standardizeExtension('+41 44 222 3344 Extension 890'),
            'Extension mixed case should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_Comma() {
        System.assertEquals('+41 79 444 5566;123', 
            PhoneNumberUtil.standardizeExtension('+41 79 444 5566,123'),
            'Comma format should convert to semicolon');
        System.assertEquals('+41 79 444 5566;123', 
            PhoneNumberUtil.standardizeExtension('+41 79 444 5566, 123'),
            'Comma with space should convert to semicolon');
    }
    
    @isTest
    static void testStandardizeExtension_NoExtension() {
        System.assertEquals('+41 44 777 8899', 
            PhoneNumberUtil.standardizeExtension('+41 44 777 8899'),
            'Phone without extension should remain unchanged');
        System.assertEquals('+41 44 123 45 67', 
            PhoneNumberUtil.standardizeExtension('+41 44 123 45 67'),
            'International number should remain unchanged');
    }
    
    @isTest
    static void testStandardizeExtension_AlreadyStandardized() {
        System.assertEquals('+41 44 999 0011;123', 
            PhoneNumberUtil.standardizeExtension('+41 44 999 0011;123'),
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
    static void testStandardizeExtension_DoubleZeroPrefix() {
        System.assertEquals('+41 44 123 4567',
            PhoneNumberUtil.standardizeExtension('0041 44 123 4567'),
            '0041 should convert to +41');
        System.assertEquals('+49 30 123456',
            PhoneNumberUtil.standardizeExtension('0049 30 123456'),
            '0049 should convert to +49');
        System.assertEquals('+1 555 123 4567',
            PhoneNumberUtil.standardizeExtension('001 555 123 4567'),
            '001 should convert to +1');
        System.assertEquals('+41 44 123 4567;100',
            PhoneNumberUtil.standardizeExtension('0041 44 123 4567 ext 100'),
            '00 prefix with extension should convert both');
        // Edge case: just "00" should not convert to just "+"
        System.assertEquals('00',
            PhoneNumberUtil.standardizeExtension('00'),
            'Just 00 should remain unchanged');
    }

    @isTest
    static void testStandardizeExtension_FormattingCleanup() {
        System.assertEquals('+41 (44) 333-4455;890', 
            PhoneNumberUtil.standardizeExtension('+41 ( 44 ) 333 - 4455 ext 890'),
            'Should clean up extra spaces in formatting');
    }
    
    @isTest
    static void testIsValidFormat_Valid() {
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 4567'), 
            'Basic format should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+41 (44) 123 4567'), 
            'Format with parentheses should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 45 67'), 
            'International format should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 4567;123'), 
            'Format with extension should be valid');
        System.assert(PhoneNumberUtil.isValidFormat(null), 
            'Null should be valid');
        System.assert(PhoneNumberUtil.isValidFormat(''), 
            'Empty string should be valid');
    }
    
    @isTest
    static void testIsValidFormat_Invalid() {
        System.assert(!PhoneNumberUtil.isValidFormat('044 123 4567'),
            'Missing country code should be invalid');
        System.assert(!PhoneNumberUtil.isValidFormat('+'),
            'Just plus sign should be invalid');
        System.assert(!PhoneNumberUtil.isValidFormat('+41 123'),
            'Too few digits should be invalid');
        System.assert(!PhoneNumberUtil.isValidFormat('+41'),
            'Too short should be invalid');
    }

    @isTest
    static void testIsValidFormat_DummyNumbers() {
        // Local number (after first 3 digits) all same digit - should be invalid
        // +41 00 000 0000 -> digits 41000000000 -> skip 410 -> local 00000000 (all zeros)
        System.assert(!PhoneNumberUtil.isValidFormat('+41 00 000 0000'),
            'Local part all zeros should be invalid');
        // +41 11 111 1111 -> digits 41111111111 -> skip 411 -> local 11111111 (all ones)
        System.assert(!PhoneNumberUtil.isValidFormat('+41 11 111 1111'),
            'Local part all ones should be invalid');
        // +1 999 999 9999 -> digits 19999999999 -> skip 199 -> local 99999999 (all nines)
        System.assert(!PhoneNumberUtil.isValidFormat('+1 999 999 9999'),
            'Local part all nines should be invalid');

        // Valid country code with varied local number - should be valid
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 4567'),
            'Normal Swiss number should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+1 555 123 4567'),
            'Normal US number should be valid');

        // Sequential patterns - should be valid (not blocked)
        System.assert(PhoneNumberUtil.isValidFormat('+12 34 567 8901'),
            'Sequential ascending should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+98 76 543 2109'),
            'Sequential descending should be valid');

        // Partial repetition in local part - should be valid
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 111 2233'),
            'Partial repetition should be valid');
    }

    @isTest
    static void testIntegration_Account() {
        Account acc = new Account(
            Name = 'Test Company',
            Phone = '+41 44 123 4567x100',
            Fax = '+41 44 987 6543 ext 200',
            BillingCountry = 'Switzerland',
            SalesChannelPick__c = 'Retail',
            SubChannelPick__c = 'Supermarket'
        );
        
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        acc = [SELECT Phone, Fax FROM Account WHERE Id = :acc.Id];
        System.assertEquals('+41 44 123 4567;100', acc.Phone, 
            'Account Phone should be standardized');
        System.assertEquals('+41 44 987 6543;200', acc.Fax, 
            'Account Fax should be standardized');
    }
    
    @isTest
    static void testIntegration_Contact() {
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Phone = '+41 44 123 4567x123',
            MobilePhone = '+41 79 234 5678 Ext. 890',
            HomePhone = '+41 44 987 6543,456',
            OtherPhone = '+41 79 876 5432 extension 789',
            AssistantPhone = '+41 44 555 1234X111',
            Fax = '+41 44 666 7890 EXT 333'
        );
        
        Test.startTest();
        insert con;
        Test.stopTest();
        
        con = [SELECT Phone, MobilePhone, HomePhone, OtherPhone, AssistantPhone, Fax 
               FROM Contact WHERE Id = :con.Id];
        System.assertEquals('+41 44 123 4567;123', con.Phone);
        System.assertEquals('+41 79 234 5678;890', con.MobilePhone);
        System.assertEquals('+41 44 987 6543;456', con.HomePhone);
        System.assertEquals('+41 79 876 5432;789', con.OtherPhone);
        System.assertEquals('+41 44 555 1234;111', con.AssistantPhone);
        System.assertEquals('+41 44 666 7890;333', con.Fax);
    }
    
    @isTest
    static void testIntegration_Lead() {
        Lead ld = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            Phone = '+41 44 123 4567x500',
            MobilePhone = '+41 79 234 5678 ext 600',
            Fax = '+41 44 987 6543,700',
            SalesChannelPick__c = 'Retail',
            SubChannelPick__c = 'Supermarket'
        );
        
        Test.startTest();
        insert ld;
        Test.stopTest();
        
        ld = [SELECT Phone, MobilePhone, Fax FROM Lead WHERE Id = :ld.Id];
        System.assertEquals('+41 44 123 4567;500', ld.Phone);
        System.assertEquals('+41 79 234 5678;600', ld.MobilePhone);
        System.assertEquals('+41 44 987 6543;700', ld.Fax);
    }
    
    @isTest
    static void testBulk_MultipleRecords() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(
                FirstName = 'Bulk',
                LastName = 'Test' + i,
                Phone = '+41 44 ' + Math.mod(i, 999) + ' ' + Math.mod(i * 2, 9999) + 'x' + i
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
