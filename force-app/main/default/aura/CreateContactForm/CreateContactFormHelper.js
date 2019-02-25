({
	loadForm: function(cmp) {
		// Load all contact data
		var action = cmp.get('c.init');
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				cmp.set('v.newContact', response.getReturnValue());
			}

			// Display toast message to indicate load status
			var toastEvent = $A.get('e.force:showToast');
			if (state !== 'SUCCESS') {
				toastEvent.setParams({
					title: 'Error!',
					message: ' Something has gone wrong.'
				});
			}
			toastEvent.fire();
		});
		$A.enqueueAction(action);
	},
	showToast: function(message) {
		const toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams(message);
		toastEvent.fire();
	}
});
