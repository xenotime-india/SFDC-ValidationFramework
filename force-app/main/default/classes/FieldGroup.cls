/*************************************************************************
Name : Field 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Verification Group pojo.
*************************************************************************/
public class FieldGroup extends AbstractValidateInput{
	
	/**
	* group label
	*/
	@AuraEnabled
	public String label {get;set;}

	/**
	* group name
	*/
	@AuraEnabled
	public String name {get;set;}

	/**
	* List of fields
	*/
	@AuraEnabled
	public List<Field> fields {get;set;}

    public void addField(Field fieldObj){
		fields.add(fieldObj);
	}

	/**
	* List of validation rules
	*/
	@AuraEnabled
	public List<Rule> rules {get;set;}

	public void addRule(Rule ruleObj){
		rules.add(ruleObj);
	}

	public FieldGroup() {
		this.rules = new List<Rule>();
		this.fields = new List<Field>();
	}

	public FieldGroup(String name) {
		this.name = name;
		this.rules = new List<Rule>();
		this.fields = new List<Field>();
	}
}