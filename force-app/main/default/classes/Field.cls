/*************************************************************************
Name : Field 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Verification field pojo.
*************************************************************************/
public class Field extends AbstractValidateInput{
  /**
  * Name of the field
  */
  @AuraEnabled
  public String name {get;set;}

  /**
  * field value
  */
  @AuraEnabled
  public String value {get;set;}

  /**
  * field dataType
  */
  @AuraEnabled
  public String dataType {get;set;}
  
  /**
  * field label
  */
  @AuraEnabled
  public String label {get;set;}

  /**
  * field label
  */
  @AuraEnabled
  public Boolean asyncValidate {get; set;}
  
  /**
  * List of validation rules
  */
  @AuraEnabled
  public List<Rule> rules {get;set;}

  public void addRule(Rule rule){
    rules.add(rule);
  }

  public Field() {
    this.asyncValidate = false;
    this.rules = new List<Rule>();
  }

  public Field(String name, String label, String dataType) {
    this.name = name;
    this.label = label;
    this.dataType = dataType;
    this.asyncValidate = false;
    this.value = '';
    this.rules = new List<Rule>();
  }
}