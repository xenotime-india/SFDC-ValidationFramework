/*************************************************************************
Name : ContactController 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Controller class for CreateContactForm lc
*************************************************************************/

public with sharing class ContactController {
  
  @AuraEnabled
  public static Form init() {
    Form formObj = new Form();

    // first name field with REQUIRED validation
    Field firstName = new Field('FirstName', 'First Name', 'text');
    firstName.addRule(new Rule('REQUIRED', 'First Name is required'));

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
  public static Map<String, String> createContact(String payload) {
    System.debug('payload =>' + payload);
    List<Object> untypedInputObjects = (List<Object>)((Map<String, Object>) JSON.deserializeUntyped(payload)).get('inputs');
    List<AbstractValidateInput> fields = new List<AbstractValidateInput>();
    for(Object untypedInputObject : untypedInputObjects) {
      String fieldPayload = JSON.serialize(untypedInputObject);
      System.debug('fieldPayload =>' + fieldPayload);
      
      String typeName = (String) ( (Map<String, Object>) JSON.deserializeUntyped(fieldPayload) ).get('className');
      System.debug('typeName =>' + typeName);
      fields.add((AbstractValidateInput)JSON.deserialize(fieldPayload, Type.forName(typeName)));
    }
    
    System.debug('fields =>' + fields);
    
    ValidateService validationServiceObj = new ValidateService();

    Map<String, String> errorMessageMap = validationServiceObj.validate(fields);
    
    System.debug('errorMessageMap =>' + errorMessageMap);
    if(!errorMessageMap.isEmpty()) {
      return errorMessageMap;
    }
    Contact newContactObj = new Contact();
    validationServiceObj.fieldsToObjectMapping(newContactObj, fields);
    
    insert newContactObj;

    return null;
  }
}