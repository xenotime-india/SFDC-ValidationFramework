/*************************************************************************
Name : IValidateService 
Author : Sandeep Kumar
Date : February 22th,2019
Usage : Interface for define Validate Service.
*************************************************************************/
public interface IValidateService {
  /**
  * initialization
  */
  void init();
  
  /**
  * Perform verification on form's field
  * @param fields (list of form fields)
  * @return Returns the verification result. If the quantity is 0, it means correct.
  */
  Map<String,String> validate(List<Field> fields);
}