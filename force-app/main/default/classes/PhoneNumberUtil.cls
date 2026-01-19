public class PhoneNumberUtil {
    
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
     * - Must start with + followed by digit
     * - Minimum 7 digits
     * - Not a dummy number (all same digit)
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

        // Check for dummy patterns (all same digit)
        if (isAllSameDigit(digitsOnly)) {
            return false;
        }

        // Format validation: allowed characters only
        String regex = '^\\+\\d[\\d\\s\\-\\(\\)\\.]{4,48}(;\\d{1,10})?$';
        return Pattern.matches(regex, phoneNumber);
    }

    /**
     * Checks if the local number (after country code) contains all the same digit
     * Country codes are 1-3 digits, so we skip the first 3 digits and check the rest
     */
    private static Boolean isAllSameDigit(String digits) {
        // Need at least 7 digits total (up to 3 for country code + at least 4 for local)
        if (digits.length() < 7) {
            return false;
        }

        // Skip first 3 digits (max country code length) and check the rest
        String localNumber = digits.substring(3);

        // Need at least 4 digits in local part to check
        if (localNumber.length() < 4) {
            return false;
        }

        String firstDigit = localNumber.substring(0, 1);
        return localNumber.replaceAll(firstDigit, '').length() == 0;
    }
}
