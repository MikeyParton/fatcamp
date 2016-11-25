// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery

//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require croppie
//= require Chart.min
//= require_tree .

$(document).on('keyup', '.js-show-btns', function(event) {
  	show_action_buttons(event);
  });

$(document).on('change', '.js-show-btns-file', function(event) {
	show_action_buttons(event);
});

$(document).on('click', '.js-cancel', function(event) {
	js_cancel_change(event);
});

$( document ).on('turbolinks:load', function() {
  if ($(".alert").length > 0){
  	flash_animate();
  }
});

function show_action_buttons(event) {
	var form = $(event.target).closest("form");
	var action_btns = form.find(".action-buttons, .image-action-buttons");
	action_btns.fadeIn();
}

function js_cancel_change(event) {
	var action_btns = $(event.target).closest(".action-buttons, .image-action-buttons ")[0];
	var form = $(event.target).closest("form")[0];
	var image_preview = $(form).find(".image-preview")

	form.reset();
	$(action_btns).fadeOut();

	if (image_preview.length != 0) {
		image_preview.slideUp();
	}
}

function flash_animate() {
	setTimeout( function(){
		flash = $(".flash-group").not(".deleting").first();
		flash.addClass("deleting");
		console.log(flash.find('.alert'))
		flash.find('.alert').addClass("slideExit")
		$(flash).fadeOut( 400, function(){
			this.remove();
		}) 
	}, 4000);
}