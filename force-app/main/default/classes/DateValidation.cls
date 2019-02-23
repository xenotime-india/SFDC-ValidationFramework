/*************************************************************************
   Name : DateValidation
   Author : Sandeep Kumar
   Date : February 23th,2019
   Usage : Validator implemention for check date by today.
*************************************************************************/
public class DateValidation implements IValidator {

  /**
  * processing required field validation logic
  * @param field or group Object Object value
  * @param rule Object parameter
  * @return whether succeed
  */
  public boolean execute(AbstractValidateInput inputObj, Rule ruleObj) {
    Field fieldObj = (inputObj.className == 'Field') ? (Field) inputObj : null;
    if(fieldObj == null || String.isBlank(fieldObj.value)) {
      return true;
    }
    Date inputDate = Date.valueOf(fieldObj.value);
    String condition = ruleObj.getParameter('condition');
    String yearString = ruleObj.getParameter('year');
    String monthString = ruleObj.getParameter('month');
    String dayString = ruleObj.getParameter('day');

    Integer year = String.isNotBlank(yearString) && yearString.isNumeric() ? Integer.valueOf(yearString) : -1;
    Integer month = String.isNotBlank(monthString) && monthString.isNumeric() ? Integer.valueOf(monthString) : -1;
    Integer day = String.isNotBlank(dayString) && dayString.isNumeric() ? Integer.valueOf(dayString) : 0;

    Integer checkValue = (year != -1) ? year : (month != -1 ? month : day);
    
    switch on condition {
      when 'lt' {
        return checkValue > this.calculateDiff(year, month, day, inputDate);
      }
      when 'lte' {
        return checkValue >= this.calculateDiff(year, month, day, inputDate);
      }
      when 'gt' {
        return checkValue < this.calculateDiff(year, month, day, inputDate);
      }
      when 'gte' {
        return checkValue <= this.calculateDiff(year, month, day, inputDate);
      }
      when else {
        return true;
      }
    }
  }

  public Integer calculateDiff(Integer year, Integer month, Integer day, Date inputDate) {
    Integer numberDaysDiff = inputDate.daysBetween(Date.today());
    return (year != -1) ? Integer.valueOf(numberDaysDiff/365) : (month != -1 ? Integer.valueOf(numberDaysDiff/12) : numberDaysDiff);
  }
}