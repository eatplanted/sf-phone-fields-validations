public class PhoneNumberUtil {
    
    /**
     * Standardizes phone number extensions to RFC 3966 format (semicolon)
     * Handles: x, X, ext, EXT, Ext., extension, EXTENSION, comma - with or without spaces
     * Case-insensitive matching
     */
    public static String standardizeExtension(String phoneNumber) {
        if (String.isBlank(phoneNumber)) {
            return phoneNumber;
        }
        
        String standardized = phoneNumber.trim();
        
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
     * Must start with + followed by digit, 7-50 chars total
     */
    public static Boolean isValidFormat(String phoneNumber) {
        if (String.isBlank(phoneNumber)) {
            return true; // Blank is allowed
        }
        
        // Must start with + and digit, 7-50 chars total
        String regex = '^\\+\\d[\\d\\s\\-\\(\\)\\.]{5,48}(;\\d{1,10})?$';
        return Pattern.matches(regex, phoneNumber);
    }
}
