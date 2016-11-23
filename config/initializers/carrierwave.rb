CarrierWave.configure do |config|
	config.fog_provider = 'fog/google'  
	config.fog_credentials = {

	    :provider                         => "Google",
	    :google_storage_access_key_id     => "GOOGYYV3CILLK22M2L5X",
	    :google_storage_secret_access_key => "51UhrUcJDjs2hAbH0RAB4s4H3BIMGXZpOezXsWST"

	    }

	    config.fog_directory = "fatcamp"
end