$( document ).on('turbolinks:load', function() {
  image_previewer();
  ajax_form_submitter();
});

function ajax_form_submitter() {

$(".js-submit").on("click", function(event){
	console.log("ajax_form_submit started");
	var form = $(event.target).closest("form")[0];
	var data = $(form).serializeJSON() || {};
	var type = form.id.includes("new") ? "POST" : "PATCH";
	console.log(form);
		
	$.when(get_image_data(form)).then(
		function (response) {
			$(form).find(".loading").show();
			if (response.image) {
				if (!data[response.resource]) data[response.resource] = {};
				data[response.resource][response.field] = response.image;
			}
			$.ajax({
	    	url : form.action,
	    	data : data,
	    	type : type,
			})
				.done(function(){
					console.log("done");	
				})
				.fail(function(){
					console.log("fail");	
				})
				.always(function(){
					console.log("completed");	
				})
    	return true;
		}
	);
});
}

function image_previewer(event) {

$(".js-image-preview").on("change", function(event){

	var source = event.target;
	var file = source.files[0];
	var form = $($(source).closest("form"))
	var container = $($(source).parent()[0]);
	var preview_target = $("#" + source.id + "_preview");
	form.find(".image-action-buttons").show();
  var input = $(event.currentTarget);
  var settings;
  var type_error = "<span class='error'>Please upload a valid image file (.jpg / .jpeg / .png / .gif)</span>"
  
  container.find(".error").remove();
  container.removeClass("field_with_errors");

  switch (true) {
	  case (source.id.includes("profile_pic")):
	    settings = profile_pic_crop_settings()
	    break;
	  case (source.id.includes("cover_pic")):
	    settings = cover_pic_crop_settings()
	    break;
	  case (source.id.includes("post_image")):
	  	settings = post_image_crop_settings();
	  	break;
	  default: 
	  	console.log("couldn't get croppie settings based on preview_target: " + preview_target);  
	}

	if (file) {
		if (file.name.search(/\.(gif|jpg|jpeg|tiff|png)$/i) != -1) {
			
			intitialize_croppie(preview_target, settings);
			var reader = new FileReader();
			reader.onload = function(event) {
	    	preview_target.croppie('bind', {
			  	url: event.target.result,
				});
	   	};

			preview_target.slideDown(1000, function() {
				$(preview_target).croppie('bind');
			});

			reader.readAsDataURL(file); 
		}
		else {
			container.addClass("field_with_errors");
			container.append(type_error);
			preview_target.slideUp();
		}
	}

});	
}

function get_image_data(form) {
console.log("startedgetimage")
var defer = $.Deferred();
var image = $(form).find("input[type='file']")[0];
var image_file = image.files[0];

if (image_file) {
	var resource = $(image).attr("resource");
	var field = $(image).attr("field");
	var preview = $(form).find(".image-preview")[0];

	$(preview).croppie('result', {
  	type: 'canvas',
    size: 'viewport',
    format: 'jpg'
	}).then(function(response) {
		defer.resolve({
			status: "image data delivered",
			image: response, 
			resource: resource, 
			field: field 
		});
	});
}
else {
	defer.resolve({ 
		status: "no image found in form" 
	});
}
return defer.promise();
}

function intitialize_croppie(preview_target, settings) {
if (preview_target.hasClass("croppie-container")){
	preview_target.croppie('destroy');
}
var cropped_image = preview_target.croppie(settings);
}

function profile_pic_crop_settings() {
return({
	viewport: {
    width: 200,
    height: 200,
    type: 'circle'
	},
  boundary: {
    width: 300,
    height: 300
	}
});
}

function cover_pic_crop_settings() {
return({
	viewport: {
    width: 300,
    height: 200,
    type: 'square'
	},
  boundary: {
    width: 300,
    height: 300
	}
});
}

function post_image_crop_settings() {
return({
	viewport: {
    width: 300,
    height: 200,
    type: 'square'
	},
  boundary: {
    width: 300,
    height: 300
	}
});
}