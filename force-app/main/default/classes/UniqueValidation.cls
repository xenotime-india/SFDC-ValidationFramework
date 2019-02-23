/*************************************************************************
  Name : UniqueValidation
  Author : Sandeep Kumar
  Date : February 23th,2019
  Usage : Validator implemention for check unique field.
*************************************************************************/
public class UniqueValidation implements IValidator {

  /**
  * processing required field validation logic
  * @param field or group Object Object value
  * @param rule Object parameter
  * @return whether succeed
  */
  public boolean execute(AbstractValidateInput inputObj, Rule ruleObj) {
    Field fieldObj = (inputObj.className == 'Field') ? (Field) inputObj : null;
    if(fieldObj == null || String.isBlank(fieldObj.value)) {
      return true;
    }

    String fieldApiName = ruleObj.getParameter('fieldName');
    String sObjectName = ruleObj.getParameter('sObjectName');
  
    if(String.isBlank(sObjectName)
      || !Schema.getGlobalDescribe().containsKey(sObjectName.toLowerCase())) {
      return true;
    }
    SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName.toLowerCase());
    
    if(String.isBlank(fieldApiName)
      || !sObjectType.getDescribe().fields.getMap().containsKey(fieldApiName.toLowerCase())) {
      return true;
    }

    String searchValue = fieldObj.value;
    String soqlQuery = 'SELECT Id FROM ' + sObjectName + ' WHERE ' + fieldApiName + ' = :searchValue LIMIT 1';

    List<sObject> sObjectlist = Database.query(soqlQuery);
    return sObjectlist.size() == 0;
  }
}