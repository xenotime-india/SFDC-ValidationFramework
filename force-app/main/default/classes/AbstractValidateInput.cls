/*************************************************************************
Name : AbstractValidateInput 
Author : Sandeep Kumar
Date : February 22th,2019
Usage : This abstract handle field and group for validation
*************************************************************************/
public abstract class AbstractValidateInput {

  @AuraEnabled
  public String className{ get {
    return String.valueOf(this).split(':')[0];
  }}
}