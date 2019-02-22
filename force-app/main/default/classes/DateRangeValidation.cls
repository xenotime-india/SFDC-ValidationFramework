/*************************************************************************
Name : DateRangeValidation 
Author : Sandeep Kumar
Date : February 22th,2019
Usage : Validator implemention for check date range in group of 2 fields.
*************************************************************************/
public class DateRangeValidation implements IValidator {
    
  /**
  * processing Date Range field validation logic
  * @param field or group Object Object value
  * @param rule Object parameter
  * @return whether succeed
  */
	public boolean execute(AbstractValidateInput inputObj, Rule ruleObj) {
		FieldGroup groupObj = (inputObj.className == 'FieldGroup') ? (FieldGroup) inputObj : null;
    if(groupObj == null && groupObj.fields.size() == 0) {
      return true;
    }
    String fromFieldName = ruleObj.getParameter('fromFieldName');
    String toFieldName = ruleObj.getParameter('toFieldName');
    String rangeDaysString = ruleObj.getParameter('rangeDays');
    String rangeType = ruleObj.getParameter('rangeType');
    Integer rangeDays = rangeDaysString.isNumeric() ? Integer.valueOf(rangeDaysString) : -1;
    if(rangeDays == -1 || String.isBlank(fromFieldName) || String.isBlank(toFieldName) || String.isBlank(rangeType)) {
			return false;
    }
    Field fromField, toField = null;
    for(Field fieldObj : groupObj.fields) {
      if(fieldObj.name == fromFieldName) {
        fromField = fieldObj;
      } else if(fieldObj.name == toFieldName) {
        toField = fieldObj;
      }
    }
    if(fromField == null || toField == null) {
      return false;
    }
    if(String.isBlank(fromField.value) && String.isBlank(toField.value)) {
      return true;
    }
    if(String.isBlank(fromField.value) || String.isBlank(toField.value)
        || fromField.dataType != 'date' || toField.dataType != 'date' ){
      return false;
    }

    Date fromDate = Date.valueOf(fromField.value);
    Date toDate = Date.valueOf(toField.value);

    Integer numberDaysDiff = fromDate.daysBetween(toDate);

    return rangeType == 'max' ? numberDaysDiff <= rangeDays: numberDaysDiff >= rangeDays;
	}
}