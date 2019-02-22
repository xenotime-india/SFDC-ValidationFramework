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

        // last name field with REQUIRED validation
        Field lastName = new Field('LastName', 'Last Name', 'text');
        lastName.addRule(new Rule('REQUIRED', 'Last Name is required'));

        formObj.addInput(lastName);

        // Email field without any validation
        Field email = new Field('Email', 'Email', 'email');

        formObj.addInput(email);

        // BirthDate field without any validation
        Field birthDate = new Field('BirthDate', 'Birth Date', 'date');

        formObj.addInput(birthDate);

        // experience field with group validation
        FieldGroup experience = new FieldGroup('experience');
        experience.addField(new Field('JobStartDate__c', 'Job Start Date', 'date'));
        experience.addField(new Field('JobEndDate__c', 'Job End Date', 'date'));

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
        
        //List<IValidateInput> fields = formObj.inputs;
        System.debug('fields =>' + fields);
        
        ValidateService validationServiceObj = new ValidateService();

        Map<String, String> errorMessageMap = validationServiceObj.validate(fields);
        
        System.debug('errorMessageMap =>' + errorMessageMap);
        if(!errorMessageMap.isEmpty()) {
            return errorMessageMap;
        }
        /*
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
        insert newContactObj;*/
        return null;
    }
}