/*************************************************************************
Name : ContactController 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Controller class for CreateContactForm lc
*************************************************************************/

public with sharing class ContactController {

  //String Constant for Success Message
  private static final string SUCCESS_MESSAGE = 'Record created successfully';

  //String Constant for Error Message
  private static final string ERROR_MESSAGE = 'Error Message From Apex: n';
  
  @AuraEnabled
  public static Form init() {
    Form formObj = new Form();

    // first name field with REQUIRED validation
    Field firstName = new Field('FirstName', 'First Name', 'text');
    firstName.addRule(new Rule('REQUIRED', 'First Name is required'));
    //firstName.asyncValidate = true;

    formObj.addInput(firstName);

    // last name field with REQUIRED & MAX_LENGTH validation
    Field lastName = new Field('LastName', 'Last Name', 'text');
    lastName.addRule(new Rule('REQUIRED', 'Last Name is required'));
    Rule lastNameRule = new Rule('MAX_LENGTH', 'Last Name must be of maximum 40 characters length');
    lastNameRule.addParameter('value', '40');
    lastName.addRule(lastNameRule);

    formObj.addInput(lastName);

    // Email field without any validation
    Field email = new Field('Email', 'Email', 'email');
    Rule emailRule = new Rule('UNIQUE', 'Email address is already in use');
    emailRule.addParameter('fieldName', 'email');
    emailRule.addParameter('sObjectName', 'contact');
    email.addRule(emailRule);

    formObj.addInput(email);

    // BirthDate field with date validation
    Field birthDate = new Field('BirthDate', 'Birth Date', 'date');
    
    Rule birthDateRule = new Rule('DATE_CHECK', 'Your are under 18 years of age.');
    birthDateRule.addParameter('condition', 'gte');
    birthDateRule.addParameter('year', '18');

    birthDate.addRule(birthDateRule);

    formObj.addInput(birthDate);

    // jobStartDate field with date validation
    Field jobStartDate = new Field('JobStartDate__c', 'Job Start Date', 'date');

    // jobStartDate field with date validation
    Field jobEndDate = new Field('JobEndDate__c', 'Job End Date', 'date');

    Rule jobDateRule = new Rule('DATE_CHECK', 'Date should not greater than today.');
    jobDateRule.addParameter('condition', 'gte');

    jobStartDate.addRule(jobDateRule);
    jobEndDate.addRule(jobDateRule);

    // experience field with group validation
    FieldGroup experience = new FieldGroup('experience');
    experience.addField(jobStartDate);
    experience.addField(jobEndDate);

    Rule dateRangeRule = new Rule('GROUP_DATE_RANGE', 'Experience should not be less then 6 months');
    dateRangeRule.addParameter('fromFieldName', 'JobStartDate__c');
    dateRangeRule.addParameter('toFieldName', 'JobEndDate__c');
    dateRangeRule.addParameter('rangeDays', '182');
    dateRangeRule.addParameter('rangeType', 'min');
    
    experience.addRule(dateRangeRule);

    formObj.addInput(experience);

    return formObj;
  }

  @AuraEnabled
  public static AuraProcessingMessage createContact(String payload) {
    //Initializing the wrapper message
    AuraProcessingMessage returnMessage = new AuraProcessingMessage();

    try{
      List<Object> untypedInputObjects = (List<Object>)((Map<String, Object>) JSON.deserializeUntyped(payload)).get('inputs');
      List<AbstractValidateInput> fields = new List<AbstractValidateInput>();
      for(Object untypedInputObject : untypedInputObjects) {
        String fieldPayload = JSON.serialize(untypedInputObject);
        
        String typeName = (String) ( (Map<String, Object>) JSON.deserializeUntyped(fieldPayload) ).get('className');
        fields.add((AbstractValidateInput)JSON.deserialize(fieldPayload, Type.forName(typeName)));
      }
      
      ValidateService validationServiceObj = new ValidateService();
      Map<String, String> errorMessageMap = validationServiceObj.validate(fields);
      
      if(!errorMessageMap.isEmpty()) {
        throw new ValidationException(errorMessageMap);
      }
      Contact newContactObj = new Contact();
      validationServiceObj.fieldsToObjectMapping(newContactObj, fields);
      
      insert newContactObj;

      //Adding the success message if the record is created
      returnMessage.successMsg=SUCCESS_MESSAGE;
    } catch(ValidationException ex) {
        system.debug('Debug Exception Message'+ex.getMessage());
        returnMessage.isSuccess = false;

        //Adding the validation message if an validationException is occured
        returnMessage.validationMsg = ex.validationMsg;
    } catch(Exception ex) {
      system.debug('Debug Exception Message'+ex.getMessage());
      returnMessage.isSuccess = false;

      //Adding the error message if an exception is occured
      returnMessage.errorMsg = ERROR_MESSAGE + ex.getMessage();
    }
    //Return the error message
    return returnMessage;
  }

/************************************************************
  Name: AuraProcessingMessage
  Type: Wrapper  Class
  Purpose: Wrapper  Class to hold error and success
          message to  display in  lightning component
***********************************************************/
  public class AuraProcessingMessage {

    @AuraEnabled 
    public Boolean isSuccess { get; set; }
    
    @AuraEnabled 
    public String errorMsg { get; set; } //error msg
    
    @AuraEnabled 
    public Map<String, String> validationMsg { get; set; } //error msg
    
    @AuraEnabled 
    public String successMsg { get; set; } //success msg

    public AuraProcessingMessage(){
      isSuccess = true;
      validationMsg = new Map<String, String>();
    }
  }

  public class ValidationException extends Exception {
    public Map<String, String> validationMsg { get; set; }

    public ValidationException(Map<String, String> validationMsg) {
      this.validationMsg = validationMsg;
    }
  }
}