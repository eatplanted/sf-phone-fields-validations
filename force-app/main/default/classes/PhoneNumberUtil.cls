public class PhoneNumberUtil {

    // Cached set of valid country codes from Country__c
    private static Set<String> validCountryCodes;

    /**
     * Gets valid country codes from Country__c (cached for performance)
     */
    public static Set<String> getValidCountryCodes() {
        if (validCountryCodes == null) {
            validCountryCodes = new Set<String>();
            for (Country__c country : [
                SELECT Phone_Country_Code__c
                FROM Country__c
                WHERE Phone_Country_Code__c != null
            ]) {
                validCountryCodes.add(country.Phone_Country_Code__c);
            }
        }
        return validCountryCodes;
    }

    /**
     * Clears the country code cache (useful for testing)
     */
    @TestVisible
    private static void clearCache() {
        validCountryCodes = null;
    }

    /**
     * Extracts the country code from a phone number
     * Tries 3, 2, then 1 digit country codes
     * Returns null if no valid country code found
     */
    public static String extractCountryCode(String phoneNumber) {
        if (String.isBlank(phoneNumber) || !phoneNumber.startsWith('+')) {
            return null;
        }

        String digitsOnly = phoneNumber.substring(1).replaceAll('[^0-9]', '');
        if (digitsOnly.length() < 1) {
            return null;
        }

        Set<String> codes = getValidCountryCodes();

        // Try 3-digit, then 2-digit, then 1-digit country codes
        for (Integer len = 3; len >= 1; len--) {
            if (digitsOnly.length() >= len) {
                String potentialCode = digitsOnly.substring(0, len);
                if (codes.contains(potentialCode)) {
                    return potentialCode;
                }
            }
        }

        return null;
    }

    /**
     * Checks if phone number has a valid country code
     */
    public static Boolean hasValidCountryCode(String phoneNumber) {
        return extractCountryCode(phoneNumber) != null;
    }

    /**
     * Standardizes phone numbers:
     * - Converts international prefix 00 to + (e.g., 0041 -> +41)
     * - Converts extensions to RFC 3966 format (semicolon)
     * - Handles: x, X, ext, EXT, Ext., extension, EXTENSION, comma
     */
    public static String standardizeExtension(String phoneNumber) {
        if (String.isBlank(phoneNumber)) {
            return phoneNumber;
        }

        String standardized = phoneNumber.trim();

        // Replace ++ with + (common typo)
        standardized = standardized.replace('++', '+');

        // Convert international dialing prefix 00 to + (e.g., 0041 -> +41)
        // Only convert if there are digits after 00 (minimum 3 chars: 00 + at least 1 digit)
        if (standardized.startsWith('00') && standardized.length() > 2) {
            standardized = '+' + standardized.substring(2);
        }

        // Pattern to match various extension formats (case-insensitive)
        // Matches: x123, X123, ext123, Ext. 123, EXT 123, extension 890, EXTENSION 456, ,123
        String extensionPattern = '(?i)\\s*([xX]|ext\\.?|extension|,)\\s*(\\d{1,10})';
        
        // Replace with semicolon format
        standardized = standardized.replaceAll(extensionPattern, ';$2');
        
        // Clean up extra spaces
        standardized = standardized.replaceAll('\\s+', ' ').trim();
        
        // Clean up spacing around formatting characters
        standardized = standardized.replaceAll('\\(\\s+', '(');
        standardized = standardized.replaceAll('\\s+\\)', ')');
        standardized = standardized.replaceAll('\\s*-\\s*', '-');
        
        return standardized;
    }
    
    /**
     * Validates phone number format
     * - Must start with + followed by valid country code
     * - Minimum 7 digits
     * - Not a dummy number (all same digit in local part)
     */
    public static Boolean isValidFormat(String phoneNumber) {
        if (String.isBlank(phoneNumber)) {
            return true; // Blank is allowed
        }

        // Must start with + and digit
        if (!phoneNumber.startsWith('+') || phoneNumber.length() < 2) {
            return false;
        }

        // Extract only digits (excluding extension after semicolon)
        String mainNumber = phoneNumber.contains(';')
            ? phoneNumber.substring(0, phoneNumber.indexOf(';'))
            : phoneNumber;
        String digitsOnly = mainNumber.replaceAll('[^0-9]', '');

        // Minimum 7 digits required
        if (digitsOnly.length() < 7) {
            return false;
        }

        // Check if entire number is all zeros (always invalid)
        if (digitsOnly.replaceAll('0', '').length() == 0) {
            return false;
        }

        // Validate country code if Country__c records exist
        String countryCode = extractCountryCode(phoneNumber);
        Set<String> codes = getValidCountryCodes();

        if (!codes.isEmpty()) {
            // Country codes are configured - validate against them
            if (countryCode == null) {
                return false; // Invalid country code
            }

            // Check for dummy patterns in local part (after country code)
            if (isLocalPartAllSameDigit(digitsOnly, countryCode.length())) {
                return false;
            }
        } else {
            // No country codes configured - use default 3-digit skip
            if (isLocalPartAllSameDigit(digitsOnly, 3)) {
                return false;
            }
        }

        // Format validation: allowed characters only
        String regex = '^\\+\\d[\\d\\s\\-\\(\\)\\.]{4,48}(;\\d{1,10})?$';
        return Pattern.matches(regex, phoneNumber);
    }

    /**
     * Checks if the local part (after country code) is all the same digit
     * @param digits All digits from the phone number
     * @param countryCodeLength Length of the country code to skip
     */
    private static Boolean isLocalPartAllSameDigit(String digits, Integer countryCodeLength) {
        // Need enough digits for country code + local part
        if (digits.length() <= countryCodeLength) {
            return false;
        }

        // Get local number after country code
        String localNumber = digits.substring(countryCodeLength);

        // Need at least 4 digits in local part to check
        if (localNumber.length() < 4) {
            return false;
        }

        String firstDigit = localNumber.substring(0, 1);
        return localNumber.replaceAll(firstDigit, '').length() == 0;
    }
}
