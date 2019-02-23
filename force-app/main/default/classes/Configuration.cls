/*************************************************************************
Name : Configuration 
Author : Sandeep Kumar
Date : February 21th,2019
Usage : Verification configuration pojo.
*************************************************************************/
public class Configuration {
  
  /**
   * Validator mapping
   */
  public Map<String,IValidator> validators {get;set;}
  
  public Configuration() {
    this.validators = new Map<String,IValidator>();
  }
}