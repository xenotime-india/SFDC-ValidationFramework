({
  checkIfValid: function(component, event, helper) {
    const asyncValidate = component.get('v.asyncValidate');
    if (asyncValidate) {
      const inputField = event.getSource();
      const action = component.get('c.asyncValidate');
      action.setParams({
        payload: JSON.stringify({
          name: component.get('v.name'),
          value: event.getSource().get('v.value'),
          dataType: component.get('v.type'),
          rules: component.get('v.rules')
        })
      });
      action.setCallback(this, function(response) {
        const result = response.getReturnValue();

        if (result[component.get('v.name')]) {
          inputField.setCustomValidity(result[component.get('v.name')]);
        } else {
          inputField.setCustomValidity('');
        }
        inputField.reportValidity();
      });
      $A.enqueueAction(action);
    }
  },
  showHelpMessageIfInvalid: function(component, event) {
    const inputCmp = component.find('inputField');
    if (inputCmp) {
      inputCmp.showHelpMessageIfInvalid();
    }
  },
  getValidity: function(component, event) {
    const inputCmp = component.find('inputField');
    if (inputCmp) {
      return inputCmp.get('v.validity');
    }
  },
  setCustomValidity: function(component, event) {
    const inputCmp = component.find('inputField');

    const params = event.getParam('arguments');
    console.log(params, params.message);
    if (inputCmp) {
      return inputCmp.setCustomValidity(params.message);
    }
  },
  reportValidity: function(component) {
    const inputCmp = component.find('inputField');
    if (inputCmp) {
      return inputCmp.reportValidity();
    }
  }
});
