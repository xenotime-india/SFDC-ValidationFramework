public with sharing class InputController {
  
  @AuraEnabled
  public static Map <String, String> asyncValidate(String payload) {
    Field fieldObj = (Field)System.JSON.deserializeStrict(payload, Field.Class);
    
    ValidateService validationServiceObj = new ValidateService();
    Map<String, String> errorMessageMap = validationServiceObj.validate(new List<Field>{fieldObj});
    
    return errorMessageMap;
  }
}