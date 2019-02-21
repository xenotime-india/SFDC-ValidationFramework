/*************************************************************************
Name : ValidatorConfig 
Author : Sandeep Kumar
Date : February 21th,2019
Usage : Verification configuration.
*************************************************************************/
public class ValidatorConfig {
    public ValidatorConfig() {}

    public Configuration readConfiguration() {
        Configuration configuratoin = new Configuration();
        configuratoin.validators = this.readValidators();
        return configuratoin;
    }

    /**
     * Read validator
     * @return
     */
    public Map<String,IValidator> readValidators(){
        Map<String,IValidator> validators = new Map<String,IValidator>();
        List<Validator_Configuration__mdt> validatorsConfigList = [SELECT MasterLabel, QualifiedApiName, Validator_Class_Name__c FROM Validator_Configuration__mdt];

        for(Validator_Configuration__mdt validatorConfig : validatorsConfigList) {
            Validator v = new Validator();
            v.name = validatorConfig.QualifiedApiName;
            v.className = validatorConfig.Validator_Class_Name__c;
            try {
                IValidator validator = this.instanceValidator(v);
                validators.put(validatorConfig.QualifiedApiName, validator);
            } catch (Exception e) {
                System.debug(e);
            } finally {
                v = null;
            }
        }
        return validators; 
    }

    /**
     * Instantiated validator
     * @param v Verification object
     * @return Validator
     */
    public IValidator instanceValidator(Validator v) {
        Type vclassor = Type.forName(v.className);
        IValidator validatorObj = (IValidator) vclassor.newInstance();
        return validatorObj;
    }
}