({
  showToast: function(message) {
    const toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams(message);
    toastEvent.fire();
  }
});
