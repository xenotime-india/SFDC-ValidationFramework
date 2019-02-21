/*************************************************************************
Name : ContactController 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Controller class for CreateContactForm lc
*************************************************************************/

public with sharing class ContactController {

    public static Map<String, String> validate(List<Field> fields) {
        Configuration configObj = new ValidatorConfig().readConfiguration();
        
        Map<String,String> results = new Map<String,String>();
        if(fields == null || fields.isEmpty()) return results; 
        
        Map<String,IValidator> validators = configObj.validators;
        if(validators == null || validators.isEmpty()) return results;
        
        for(Field fieldObj: fields) {
            if(fieldObj.rules == null || fieldObj.rules.isEmpty()) continue;
            
            for(Rule ruleObj : fieldObj.rules) {
                IValidator validator = validators.get(ruleObj.name);
                if(validator != null && !validator.execute(fieldObj, ruleObj)) {
                    results.put(fieldObj.name, ruleObj.message);
                }
            }
        }
        
        return results;
    }
    
    @AuraEnabled
    public static Map<String, String> createContact(String payload) {
        System.debug('payload =>' + payload);
        List<Field> fields = (List<Field>)System.JSON.deserializeStrict(payload, List<Field>.Class);
        System.debug('fields =>' + fields);
        
        Map<String, String> errorMessageMap = ContactController.validate(fields);
        
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