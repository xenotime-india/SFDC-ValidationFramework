/*************************************************************************
Name : RequiredValidation 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : check required field validation .
*************************************************************************/
public class RequiredValidation {
    
    /**
	 * processing required field validation logic
	 * @param field Object Object value
	 * @param rule Object parameter
	 * @return whether succeed
	 */
	public boolean execute(Field fieldObj, Rule ruleObj) {
		return String.isNotBlank(fieldObj.value);
	}
}