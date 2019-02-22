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
    
    public Map<String, String> validate(List<Field> fields) {
        //Determine whether it is initialized
        if(!this.isInited) this.init();
        
        Map<String,String> results = new Map<String,String>();
        if(fields == null || fields.isEmpty()) return results; 
        
        Map<String,IValidator> validators = this.configuration.validators;
        if(validators == null || validators.isEmpty()) return results;
        
        for(Field fieldObj: fields) {
            if(fieldObj.rules == null || fieldObj.rules.isEmpty()) continue;
            
            for(Rule ruleObj : fieldObj.rules) {
                IValidator validator = validators.get(ruleObj.name);
                if(validator != null && !validator.execute(fieldObj, ruleObj)) {
                    results.put(fieldObj.name, ruleObj.message);
                }
            }
        }
        
        return results;
    }
}