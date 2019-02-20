({
  clickCreate: function(component, event, helper) {
    const newContact = component.get('v.newContact');
    const action = component.get('c.createContact');
    action.setParams({ newContactObj: newContact });
    action.setCallback(this, function(response) {
      const results = response.getReturnValue();
      const state = response.getState();
      if (state === 'SUCCESS') {
        // Process server success response
        helper.showToast({
          type: 'success',
          title: 'Success!',
          message: 'The record has been created successfully.'
        });
      } else if (state === 'ERROR') {
        // Process error returned by server
        const errors = response.getError();
        let message = 'Unknown error'; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors.reduce(function(accumulator, error) {
            if (error.message) {
              return accumulator + error.message;
            }
            if (error.pageErrors && error.pageErrors.length > 0) {
              return accumulator + error.pageErrors[0].message;
            }
          }, '');
        }
        helper.showToast({
          type: 'error',
          title: 'Error!',
          message: message
        });
      }
    });
    $A.enqueueAction(action);
  }
});
