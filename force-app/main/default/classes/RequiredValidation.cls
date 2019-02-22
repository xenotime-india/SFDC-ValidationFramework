/*************************************************************************
Name : RequiredValidation 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Validator implemention for check required field.
*************************************************************************/
public class RequiredValidation implements IValidator {
    
  /**
	 * processing required field validation logic
	 * @param field or group Object Object value
	 * @param rule Object parameter
	 * @return whether succeed
	 */
	public boolean execute(AbstractValidateInput inputObj, Rule ruleObj) {
		Field fieldObj = (inputObj.className == 'Field') ? (Field) inputObj : null;
		return (fieldObj == null || String.isNotBlank(fieldObj.value));
	}
}