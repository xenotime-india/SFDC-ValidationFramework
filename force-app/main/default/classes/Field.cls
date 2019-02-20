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
	 * field message
	 */
	public String message {get;set;}
    /**
	 * field isRequired
	 */
	public Boolean isRequired {get;set;}
	
    public Field() {}
	
	public override String toString() {
		return '[ name='+name+', value='+value+' ]';
	}
}