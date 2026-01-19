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
    static void testStandardizeExtension_DoublePlus() {
        System.assertEquals('+41 44 123 4567',
            PhoneNumberUtil.standardizeExtension('++41 44 123 4567'),
            '++ should be replaced with +');
        System.assertEquals('+1 555 123 4567',
            PhoneNumberUtil.standardizeExtension('++1 555 123 4567'),
            '++ at start should be replaced with +');
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
        // All zeros - should be invalid regardless of country code
        System.assert(!PhoneNumberUtil.isValidFormat('+0000000000'),
            'All zeros should be invalid');
        System.assert(!PhoneNumberUtil.isValidFormat('+00 000 0000'),
            'All zeros with spaces should be invalid');

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

    @isTest
    static void testCountryCodeValidation_WithCountryRecords() {
        // Create test country records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'Germany', ISO_Code__c = 'DE', Phone_Country_Code__c = '49'),
            new Country__c(Name = 'United States', ISO_Code__c = 'US', Phone_Country_Code__c = '1'),
            new Country__c(Name = 'United Kingdom', ISO_Code__c = 'GB', Phone_Country_Code__c = '44')
        };
        insert countries;

        // Clear cache to reload with new records
        PhoneNumberUtil.clearCache();

        Test.startTest();

        // Valid country codes
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 4567'),
            'Swiss number should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+49 30 123456'),
            'German number should be valid');
        System.assert(PhoneNumberUtil.isValidFormat('+1 555 123 4567'),
            'US number should be valid');

        // Invalid country codes - FIXED TESTS
        System.assert(!PhoneNumberUtil.isValidFormat('+999 456 7890'),
            'Number with invalid country code 999 should be invalid');

        System.assert(!PhoneNumberUtil.isValidFormat('+9911111111'),
            'Number starting with 991 (invalid) should be invalid - not Georgia 995');

        // +123 is valid because it matches country code 1 (US)
        System.assert(PhoneNumberUtil.isValidFormat('+123 456 7890'),
            '+123 should be valid as it matches country code 1');

        Test.stopTest();
    }

    @isTest
    static void testExtractCountryCode() {
        // Create test country records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'United States', ISO_Code__c = 'US', Phone_Country_Code__c = '1'),
            new Country__c(Name = 'Kazakhstan', ISO_Code__c = 'KZ', Phone_Country_Code__c = '7')
        };
        insert countries;

        PhoneNumberUtil.clearCache();

        Test.startTest();

        // Test extraction
        System.assertEquals('41', PhoneNumberUtil.extractCountryCode('+41 44 123 4567'),
            'Should extract Swiss country code 41');
        System.assertEquals('1', PhoneNumberUtil.extractCountryCode('+1 555 123 4567'),
            'Should extract US country code 1');
        System.assertEquals('7', PhoneNumberUtil.extractCountryCode('+7 777 123 4567'),
            'Should extract Kazakhstan country code 7');

        // Invalid cases
        System.assertEquals(null, PhoneNumberUtil.extractCountryCode('+99 123 4567'),
            'Should return null for invalid country code');
        System.assertEquals(null, PhoneNumberUtil.extractCountryCode('41 44 123 4567'),
            'Should return null for number without +');
        System.assertEquals(null, PhoneNumberUtil.extractCountryCode(null),
            'Should return null for null input');
        System.assertEquals(null, PhoneNumberUtil.extractCountryCode(''),
            'Should return null for empty string');

        Test.stopTest();
    }

    @isTest
    static void testHasValidCountryCode() {
        // Create test country records
        insert new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41');
        PhoneNumberUtil.clearCache();

        Test.startTest();

        System.assert(PhoneNumberUtil.hasValidCountryCode('+41 44 123 4567'),
            'Swiss number should have valid country code');
        System.assert(!PhoneNumberUtil.hasValidCountryCode('+99 123 4567'),
            'Number with code 99 should not have valid country code');

        Test.stopTest();
    }

    @isTest
    static void testDummyNumberWithCountryCode() {
        // Create test country record for Switzerland (2-digit code)
        insert new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41');
        PhoneNumberUtil.clearCache();

        Test.startTest();

        // With country code 41 (2 digits), local part starts at position 2
        // +41 00 000 0000 -> digits 41000000000 -> country code 41 -> local 000000000 (all zeros)
        System.assert(!PhoneNumberUtil.isValidFormat('+41 00 000 0000'),
            'Local part all zeros should be invalid');

        // +41 11 111 1111 -> digits 41111111111 -> country code 41 -> local 111111111 (all ones)
        System.assert(!PhoneNumberUtil.isValidFormat('+41 11 111 1111'),
            'Local part all ones should be invalid');

        // Valid number
        System.assert(PhoneNumberUtil.isValidFormat('+41 44 123 4567'),
            'Normal Swiss number should be valid');

        Test.stopTest();
    }

    @isTest
    static void testGetValidCountryCodes() {
        // Create test country records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'No Code', ISO_Code__c = 'XX') // No phone code
        };
        insert countries;

        PhoneNumberUtil.clearCache();

        Test.startTest();

        Set<String> codes = PhoneNumberUtil.getValidCountryCodes();
        System.assertEquals(1, codes.size(), 'Should only return countries with phone codes');
        System.assert(codes.contains('41'), 'Should contain Swiss code 41');

        // Test caching - second call should return same set
        Set<String> codes2 = PhoneNumberUtil.getValidCountryCodes();
        System.assertEquals(codes, codes2, 'Cached codes should be returned');

        Test.stopTest();
    }

    @isTest
    static void testGetPhoneCodeByIso() {
        // Create test country records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'Germany', ISO_Code__c = 'DE', Phone_Country_Code__c = '49'),
            new Country__c(Name = 'United States', ISO_Code__c = 'US', Phone_Country_Code__c = '1')
        };
        insert countries;

        PhoneNumberUtil.clearCache();

        Test.startTest();

        // Valid ISO codes
        System.assertEquals('41', PhoneNumberUtil.getPhoneCodeByIso('CH'),
            'Should return 41 for Switzerland');
        System.assertEquals('49', PhoneNumberUtil.getPhoneCodeByIso('DE'),
            'Should return 49 for Germany');
        System.assertEquals('1', PhoneNumberUtil.getPhoneCodeByIso('US'),
            'Should return 1 for United States');

        // Case insensitive
        System.assertEquals('41', PhoneNumberUtil.getPhoneCodeByIso('ch'),
            'Should handle lowercase ISO code');
        System.assertEquals('41', PhoneNumberUtil.getPhoneCodeByIso('Ch'),
            'Should handle mixed case ISO code');

        // Invalid/null cases
        System.assertEquals(null, PhoneNumberUtil.getPhoneCodeByIso('ZZ'),
            'Should return null for unknown ISO code');
        System.assertEquals(null, PhoneNumberUtil.getPhoneCodeByIso(null),
            'Should return null for null input');
        System.assertEquals(null, PhoneNumberUtil.getPhoneCodeByIso(''),
            'Should return null for empty string');

        Test.stopTest();
    }

    @isTest
    static void testGetIsoCodesByPhoneCode() {
        // Create test country records - US and Canada share code 1
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'United States', ISO_Code__c = 'US', Phone_Country_Code__c = '1'),
            new Country__c(Name = 'Canada', ISO_Code__c = 'CA', Phone_Country_Code__c = '1')
        };
        insert countries;

        PhoneNumberUtil.clearCache();

        Test.startTest();

        // Single country for code
        Set<String> swissIso = PhoneNumberUtil.getIsoCodesByPhoneCode('41');
        System.assertEquals(1, swissIso.size(), 'Should return one ISO code for 41');
        System.assert(swissIso.contains('CH'), 'Should contain CH for code 41');

        // Multiple countries share code 1
        Set<String> northAmericaIso = PhoneNumberUtil.getIsoCodesByPhoneCode('1');
        System.assertEquals(2, northAmericaIso.size(), 'Should return two ISO codes for 1');
        System.assert(northAmericaIso.contains('US'), 'Should contain US for code 1');
        System.assert(northAmericaIso.contains('CA'), 'Should contain CA for code 1');

        // Invalid/null cases
        Set<String> unknownIso = PhoneNumberUtil.getIsoCodesByPhoneCode('999');
        System.assertEquals(0, unknownIso.size(), 'Should return empty set for unknown code');

        Set<String> nullIso = PhoneNumberUtil.getIsoCodesByPhoneCode(null);
        System.assertEquals(0, nullIso.size(), 'Should return empty set for null');

        Test.stopTest();
    }

    @isTest
    static void testMatchesCountry() {
        // Create test country records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'Germany', ISO_Code__c = 'DE', Phone_Country_Code__c = '49'),
            new Country__c(Name = 'United States', ISO_Code__c = 'US', Phone_Country_Code__c = '1')
        };
        insert countries;

        PhoneNumberUtil.clearCache();

        Test.startTest();

        // Matching phone and country
        System.assert(PhoneNumberUtil.matchesCountry('+41 44 123 4567', 'CH'),
            'Swiss number should match CH');
        System.assert(PhoneNumberUtil.matchesCountry('+49 30 123 4567', 'DE'),
            'German number should match DE');
        System.assert(PhoneNumberUtil.matchesCountry('+1 555 123 4567', 'US'),
            'US number should match US');

        // Non-matching phone and country
        System.assert(!PhoneNumberUtil.matchesCountry('+41 44 123 4567', 'DE'),
            'Swiss number should not match DE');
        System.assert(!PhoneNumberUtil.matchesCountry('+49 30 123 4567', 'CH'),
            'German number should not match CH');

        // Blank values should pass (allow blank)
        System.assert(PhoneNumberUtil.matchesCountry(null, 'CH'),
            'Null phone should pass');
        System.assert(PhoneNumberUtil.matchesCountry('', 'CH'),
            'Empty phone should pass');
        System.assert(PhoneNumberUtil.matchesCountry('+41 44 123 4567', null),
            'Null ISO should pass');
        System.assert(PhoneNumberUtil.matchesCountry('+41 44 123 4567', ''),
            'Empty ISO should pass');

        // Unknown country should pass (skip validation)
        System.assert(PhoneNumberUtil.matchesCountry('+41 44 123 4567', 'ZZ'),
            'Unknown country should pass validation');

        Test.stopTest();
    }

    @isTest
    static void testGetIsoCodeFromPhone() {
        // Create test country records
        List<Country__c> countries = new List<Country__c>{
            new Country__c(Name = 'Switzerland', ISO_Code__c = 'CH', Phone_Country_Code__c = '41'),
            new Country__c(Name = 'United States', ISO_Code__c = 'US', Phone_Country_Code__c = '1'),
            new Country__c(Name = 'Canada', ISO_Code__c = 'CA', Phone_Country_Code__c = '1')
        };
        insert countries;

        PhoneNumberUtil.clearCache();

        Test.startTest();

        // Single country for code
        System.assertEquals('CH', PhoneNumberUtil.getIsoCodeFromPhone('+41 44 123 4567'),
            'Should return CH for Swiss number');

        // Multiple countries share code - returns first alphabetically
        System.assertEquals('CA', PhoneNumberUtil.getIsoCodeFromPhone('+1 555 123 4567'),
            'Should return CA (first alphabetically) for +1 number');

        // Invalid cases
        System.assertEquals(null, PhoneNumberUtil.getIsoCodeFromPhone('+999 123 4567'),
            'Should return null for unknown country code');
        System.assertEquals(null, PhoneNumberUtil.getIsoCodeFromPhone(null),
            'Should return null for null input');
        System.assertEquals(null, PhoneNumberUtil.getIsoCodeFromPhone(''),
            'Should return null for empty string');
        System.assertEquals(null, PhoneNumberUtil.getIsoCodeFromPhone('41 44 123 4567'),
            'Should return null for number without +');

        Test.stopTest();
    }
}
