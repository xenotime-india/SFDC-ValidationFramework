/*************************************************************************
Name : ValidateService 
Author : Sandeep Kumar
Date : February 22th,2019
Usage : verification service.
*************************************************************************/
public class ValidateService implements IValidateService {
  public Configuration configuration { get; set;}
  private IValidatorConfig config { get; set;}
  private boolean isInited { get; set;}
  
  public ValidateService() {
    this(new ValidatorConfig());
  }
  public ValidateService(IValidatorConfig config) {
    this.config = config;
    this.isInited = false;
  }
  
  public void init() {
    //Read configuration
    this.configuration = config.readConfiguration();
    
    //Settings have been initialized
    this.isInited = true;
  }
  
  public Map<String, String> validate(List<AbstractValidateInput> inputs) {
    //Determine whether it is initialized
    if(!this.isInited) this.init();
    
    Map<String,String> results = new Map<String,String>();
    if(inputs == null || inputs.isEmpty()) return results; 
    
    Map<String,IValidator> validators = this.configuration.validators;
    if(validators == null || validators.isEmpty()) return results;
    
    for(AbstractValidateInput inputObj: inputs) {
      switch on inputObj.className {
        when 'Field' {
          Field fieldObj = (Field) inputObj;
          if(fieldObj.rules == null || fieldObj.rules.isEmpty()) continue;
          
          for(Rule ruleObj : fieldObj.rules) {
            IValidator validator = validators.get(ruleObj.name);
            if(validator != null && !validator.execute(fieldObj, ruleObj)) {
              results.put(fieldObj.name, ruleObj.message);
            }
          }
        }
        when 'FieldGroup' {
          FieldGroup fieldGroupobj = (FieldGroup) inputObj;
          if(fieldGroupobj.fields == null || fieldGroupobj.fields.isEmpty()) continue;
          if(fieldGroupobj.rules != null && !fieldGroupobj.rules.isEmpty()) {
            for(Rule ruleObj : fieldGroupobj.rules) {
              IValidator validator = validators.get(ruleObj.name);
              if(validator != null && !validator.execute(fieldGroupobj, ruleObj)) {
                results.put(fieldGroupobj.name, ruleObj.message);
              }
            }
          }
          Map<String, String> fieldGroupVResults = validate(fieldGroupobj.fields);
          results.putAll(fieldGroupVResults);
        }
      }
    } 
    return results; 
  }

  public sObject fieldsToObjectMapping(Sobject sObj, List<AbstractValidateInput> inputs) {
    //Sobject sObj = Schema.getGlobalDescribe().get(sObjectName).newSObject()
    if(inputs == null || inputs.size() == 0) {
      return sObj;
    }
    for(AbstractValidateInput inputObj: inputs) {
      switch on inputObj.className {
        when 'Field' {
          Field fieldObj = (Field) inputObj;
          if(String.isNotBlank(fieldObj.value)) {
            switch on fieldObj.dataType {
              when 'date' {
                sObj.put(fieldObj.name, Date.valueOf(fieldObj.value));
              }
              when else {
                sObj.put(fieldObj.name, fieldObj.value);
              }
            }
          }
        }
        when 'FieldGroup' {
          FieldGroup fieldGroupobj = (FieldGroup) inputObj;
          fieldsToObjectMapping(sObj, fieldGroupobj.fields);
        }
      }
    }
    return sObj;
  }
}