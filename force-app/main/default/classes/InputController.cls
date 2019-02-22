public with sharing class InputController {
    
    @AuraEnabled
    public static Map <String, String> asyncValidate(String payload) {
        System.debug(payload);
        Field fieldObj = (Field)System.JSON.deserializeStrict(payload, Field.Class);
        System.debug(fieldObj);
        
        ValidateService validationServiceObj = new ValidateService();
        Map<String, String> errorMessageMap = validationServiceObj.validate(new List<Field>{fieldObj});
        
        return errorMessageMap;
    }
}