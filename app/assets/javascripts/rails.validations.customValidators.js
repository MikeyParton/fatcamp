/*
var $confirmationField, $element, handleBlur;

$confirmationField = $element = handleBlur = function() {
	$confirmationField.data("blurredOnce", true);
	$element.data("changed", true);
	return $element.isValid($element[0].form.ClientSideValidations.settings.validators);
};

ClientSideValidations.validators.local.confirmation = function(element, options) {
	$element = element;
	$confirmationField = $("#" + (element.attr('id')) + "_confirmation");
	console.log($confirmationField);
	$confirmationField.off("blur", handleBlur).on("blur", handleBlur);
	if ($confirmationField.data("blurredOnce") && $element.val() !== $confirmationField.val()) {
		return options.message;
	}
};
*/