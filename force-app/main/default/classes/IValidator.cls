/*************************************************************************
Name : IValidator 
Author : Sandeep Kumar
Date : February 21th,2019
Usage : This interface is an important interface to handle the processing of each verification.
*************************************************************************/
public interface IValidator {
    /**
	 * processing validation logic
	 * @param field or group Object Object value
	 * @param rule Object parameter
	 * @return whether succeed
	 */
    Boolean execute(AbstractValidateInput fieldObj, Rule ruleObj);
}