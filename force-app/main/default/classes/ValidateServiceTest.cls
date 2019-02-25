@isTest
public class ValidateServiceTest {
  
  @isTest static void testFormValidation() {
    // code_block
    Form formObj = new Form();

    // first name field with REQUIRED validation
    Field firstName = new Field('FirstName', 'First Name', 'text');
    firstName.addRule(new Rule('REQUIRED', 'First Name is required'));
    Rule firstNameMaxLengthRule = new Rule('MAX_LENGTH', 'First Name must be of maximum 8 characters length');
    firstNameMaxLengthRule.addParameter('value', '8');
    firstName.addRule(firstNameMaxLengthRule);

    formObj.addInput(firstName);

    // last name field with REQUIRED validation
    Field lastName = new Field();
    lastName.name = 'LastName';
    lastName.label = 'Last Name';
    lastName.dataType = 'text';
    firstName.value='Test User Last Name';
    lastName.addRule(new Rule('REQUIRED', 'Last Name is required'));
    Rule lastNameMaxLengthRule = new Rule('MAX_LENGTH', 'Last Name must be of maximum 8 characters length');
    lastNameMaxLengthRule.addParameter('value', '8');
    lastName.addRule(lastNameMaxLengthRule);

    formObj.addInput(lastName);

    // Email field without any validation
    Field email = new Field('Email', 'Email', 'email');

    formObj.addInput(email);

    // BirthDate field with date validation
    Field birthDate = new Field('BirthDate', 'Birth Date', 'date');
    birthDate.value='2019-02-19';

    Rule birthDateRule = new Rule('DATE_CHECK', 'Your are under 18 years of age.');
    birthDateRule.addParameter('condition', 'gte');
    birthDateRule.addParameter('year', '18');

    birthDate.addRule(birthDateRule);

    formObj.addInput(birthDate);

    // jobStartDate field with date validation
    Field jobStartDate = new Field('JobStartDate__c', 'Job Start Date', 'date');

    // jobStartDate field with date validation
    Field jobEndDate = new Field('JobEndDate__c', 'Job End Date', 'date');
    jobEndDate.value='2019-02-19';

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

    // executing validate service
    ValidateService validationServiceObj = new ValidateService();
    Map<String, String> errorMessageMap = validationServiceObj.validate(formObj.inputs);

    // Test that the validation correctly send error messages
    System.assertEquals(4,errorMessageMap.size());
    Contact newContactObj = new Contact();
    validationServiceObj.fieldsToObjectMapping(newContactObj, formObj.inputs);
  }
}