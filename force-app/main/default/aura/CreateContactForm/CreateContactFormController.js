({
  clickCreate: function(component, event, helper) {
    // If we pass error checking, do some real work
    const newContact = component.get('v.newContact');
    const action = component.get('c.createContact');
    action.setParams({ newContactObj: newContact });
    action.setCallback(this, function(response) {
      const results = response.getReturnValue();
      const state = response.getState();
      console.log(results, state);
    });
    $A.enqueueAction(action);
  }
});
