/*************************************************************************
Name : Configuration 
Author : Sandeep Kumar
Date : February 21th,2019
Usage : Verification configuration pojo.
*************************************************************************/
public class Configuration {
	/**
	 * Validator mapping
	 */
	public Map<String,IValidator> validators {get;set;}
	
	public void addValidator(String name,IValidator validator){
		this.validators.put(name, validator);
	}
	
	public IValidator getValidator(String name){
		return this.validators.get(name);
	}
	
	public Configuration() {
		this.validators = new Map<String,IValidator>();
	}
}