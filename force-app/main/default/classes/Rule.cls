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
    public String name {get;set;}
    /**
	 * Message after verification failed
	 */
    public String message {get;set;}
    /**
	 * parameter
	 */
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
    
    public override String toString() {
        return '[ name='+name+', message='+message+' ]';
    }
}