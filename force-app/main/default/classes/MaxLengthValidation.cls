/*************************************************************************
Name : MaxLengthValidation 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Validator implemention for check maximum allow length .
*************************************************************************/
public class MaxLengthValidation implements IValidator {
    
    /**
	 * processing required field validation logic
	 * @param field Object Object value
	 * @param rule Object parameter
	 * @return whether succeed
	 */
	public boolean execute(Field fieldObj, Rule ruleObj) {
        if(String.isBlank(fieldObj.value)) {
            return true;
        }
        Integer length = fieldObj.value.length();
        String maxString = ruleObj.getParameter('value');
        Integer max = maxString.isNumeric() ? Integer.valueOf(maxString) : -1;
        if(max == -1) {
			return false;
		}
		return length <= max;
	}
}