/*************************************************************************
Name : Form 
Author : Sandeep Kumar
Date : February 20th,2019
Usage : Verification Form pojo.
*************************************************************************/
public class Form {
    
  /**
  * List of inupts ( field or group )
  */
  @AuraEnabled
	public List<AbstractValidateInput> inputs {get;set;}

    public void addInput(AbstractValidateInput inputObj){
		inputs.add(inputObj);
	}

  public Form() {
      this.inputs = new List<AbstractValidateInput>();
  }
	
	public override String toString() {
		return '[ inputs='+inputs+' ]';
	}
}