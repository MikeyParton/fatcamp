class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	layout :layout_by_resource
	before_action :configure_permitted_parameters, if: :devise_controller?
  include PostsHelper


  protected

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end
	
	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
		devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def unique_filename
    SecureRandom.uuid
  end

  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    else
      return nil
    end
  end

  def convert_data_uri_to_upload(obj_hash)
      if obj_hash[:image].try(:match, %r{^data:(.*?);(.*?),(.*)$})
        image_data = split_base64(obj_hash[:image])
        image_data_string = image_data[:data]
        image_data_binary = Base64.decode64(image_data_string)

        temp_img_file = Tempfile.new([obj_hash[:filename],".jpg"])
        temp_img_file.binmode
        temp_img_file << image_data_binary
        temp_img_file.rewind

        img_params = {:filename => obj_hash[:filename] + ".jpg", :content_type => Mime["jpg"], :tempfile => temp_img_file, :original_filename => obj_hash[:filename] + ".jpg"}
        uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)
        uploaded_file.content_type = Mime["jpg"]
        uploaded_file.headers = "image/jpg"
        obj_hash[:url_large] = uploaded_file
        obj_hash.delete(:image)
      end

      return obj_hash   
    end
	
end
