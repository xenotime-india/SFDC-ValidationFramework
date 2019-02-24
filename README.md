# Salesforce Validation Framework
Salesforce framework for data input form validation.

## Overview
Validating data is a common task that occurs throughout any application, especially the business logic layer. As for some quite complex scenarios, often the same or similar validations are scattered everywhere, thus it is hard to reuse code and break the rule.

To avoid duplication and do validations as easy as possible, this validation framework provides the power to support validations with ease.

## Features
 - very lightweight, only ~1500 lines codes (framework + built-in extensions)
 - easy use, no verbose codes, and what you see is what you get
 - highly customizable, you can extend almost every executing point
 - easily extensible, every extension interface is an alias of FunctionN
 - immutable, you can share mapping definition object safely

## Examples
The following examples are a subset of those found in the [ContactController.cls](https://github.com/xenotime-india/SFDC-ValidationFramework/blob/master/force-app/main/default/classes/ContactController.cls)
```java
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
      return errorMessageMap;
    }
    Contact newContactObj = new Contact();
    validationServiceObj.fieldsToObjectMapping(newContactObj, fields);
    
    insert newContactObj;

    return null;
  }
```
