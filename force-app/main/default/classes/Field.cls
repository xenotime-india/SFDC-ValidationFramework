/*************************************************************************
Name : Field 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Verification field pojo.
*************************************************************************/
public class Field {
	/**
	 * Name of the field
	 */
	public String name {get;set;}
	/**
	 * field value
	 */
	public String value {get;set;}
    /**
	 * field dataType
	 */
    public String dataType {get;set;}
    /**
	 * field label
	 */
    public String label {get;set;}
    
    /**
	 * List of validation rules
	 */
	public List<Rule> rules {get;set;}

    public void addRule(Rule rule){
		rules.add(rule);
	}

    public Field() {
        this.rules = new List<Rule>();
    }
	
	public override String toString() {
		return '[ name='+name+', value='+value+', rules='+rules+' ]';
	}
}