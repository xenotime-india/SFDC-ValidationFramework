public with sharing class ContactController {
    
    @AuraEnabled
    public static Map<String, String> createContact(Contact newContactObj) {
        System.debug(newContactObj);
        return null;
    }
}