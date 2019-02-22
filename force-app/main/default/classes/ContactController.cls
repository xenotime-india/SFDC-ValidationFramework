/*************************************************************************
Name : ContactController 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Controller class for CreateContactForm lc
*************************************************************************/

public with sharing class ContactController {
    
    @AuraEnabled
    public static Map<String, String> createContact(String payload) {
        System.debug('payload =>' + payload);
        List<Field> fields = (List<Field>)System.JSON.deserializeStrict(payload, List<Field>.Class);
        System.debug('fields =>' + fields);
        
        ValidateService validationServiceObj = new ValidateService();

        Map<String, String> errorMessageMap = validationServiceObj.validate(fields);
        
        System.debug('errorMessageMap =>' + errorMessageMap);
        if(!errorMessageMap.isEmpty()) {
            return errorMessageMap;
        }
        Contact newContactObj = new Contact();
        for(Field fieldObj : fields) {
            if(String.isNotBlank(fieldObj.value)) {
                if(fieldObj.dataType == 'date') {
                    newContactObj.put(fieldObj.name, Date.parse(fieldObj.value));
                }
                else {
                    newContactObj.put(fieldObj.name, fieldObj.value);
                }
            }
        }
        System.debug('newContactObj =>' + newContactObj);
        insert newContactObj;
        return null;
    }
}