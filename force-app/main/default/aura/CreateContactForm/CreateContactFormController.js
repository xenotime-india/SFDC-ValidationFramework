({
	doInit: function(component, event, helper) {
		// Retrieve contacts during component initialization
		helper.loadForm(component);
	},
	clickCreate: function(component, event, helper) {
		const newContact = component.get('v.newContact');
		const action = component.get('c.createContact');
		action.setParams({ payload: JSON.stringify(newContact) });
		action.setCallback(this, function(response) {
			const result = response.getReturnValue();
			const state = response.getState();
			if (state === 'SUCCESS') {
				if (result.isSuccess) {
					// Process server success response
					component.find('contactform').forEach(inputCmp => {
						inputCmp.setCustomValidity('');
						inputCmp.reportValidity();
					});
					helper.loadForm(component);
					helper.showToast({
						type: 'success',
						title: 'Success!',
						message: 'The record has been created successfully.'
					});
				} else if (result.errorMsg) {
					helper.showToast({
						type: 'error',
						title: 'Error!',
						message: errorMsg
					});
				} else {
					component.find('contactform').forEach(inputCmp => {
						if (result.validationMsg[inputCmp.get('v.name')]) {
							inputCmp.setCustomValidity(result.validationMsg[inputCmp.get('v.name')]);
						} else if (result.validationMsg[inputCmp.get('v.group')]) {
							inputCmp.setCustomValidity(result.validationMsg[inputCmp.get('v.group')]);
						} else {
							inputCmp.setCustomValidity('');
						}
						inputCmp.reportValidity();
					});
				}
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
