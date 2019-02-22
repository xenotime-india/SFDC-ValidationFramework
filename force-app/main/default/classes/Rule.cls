/*************************************************************************
Name : Rule 
Author : Sandeep Kumar
Date : February 21th,2019
Usage : Verification rule pojo.
*************************************************************************/
public class Rule {
    /**
	 * Rule name
	 */
    @AuraEnabled
    public String name {get;set;}
    /**
	 * Message after verification failed
	 */
    @AuraEnabled
    public String message {get;set;}
    /**
	 * parameter
	 */
    @AuraEnabled
    public Map<String,String> parameters {get;set;}
    
    public void addParameter(String name, String value){
        this.parameters.put(name, value);
    }
    
    public String getParameter(String name){
        return this.parameters.get(name);
    }
    
    public Rule() {
        this.parameters = new Map<String, String>();
    }

    public Rule(String name, String message) {
        this.name = name;
        this.message = message;

        this.parameters = new Map<String, String>();
    }
    
    public override String toString() {
        return '[ name='+name+', message='+message+' ]';
    }
}