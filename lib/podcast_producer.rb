module PodcastProducer
	include HTTParty
	
	base_uri App.settings.pcp['ssl_library']
	basic_auth App.settings.pcp['ssl_username'], App.settings.pcp['ssl_password']
	format :xml
	
	def self.set_feed_property(feed_uuid, property_name, property_value)
		set_property('feed', feed_uuid, property_name, property_value)
	end
	
	def self.set_catalog_property(catalog_uuid, property_name, property_value)
		set_property('catalog', catalog_uuid, property_name, property_value)
	end
	
	def self.set_feed_image(feed_uuid, image, extension)
		set_image('feed', feed_uuid, image, extension)
	end
	
	def self.set_catalog_image(catalog_uuid, image, extension)
		set_image('catalog', catalog_uuid, image, extension)
	end
	
	private
	
		def self.set_property(resource_type, resource_uuid, property_name, property_value)
			success?(
				self.post("/#{resource_type}s/setproperty",
					:body => {
						:"#{resource_type}_uuid" => resource_uuid,
						:property_name => property_name,
						:property_value => property_value
					}
				)
			)
		end

		def self.set_image(resource_type, resource_uuid, image, extension)
			base64_encoded_image = Base64.encode64(image)
			success?(
				self.post("/#{resource_type}s/setimage", 
					:body => {
						:"#{resource_type}_uuid" => resource_uuid,
						:extension => "#{extension.downcase}",
						:base64_encoded_image => base64_encoded_image
						}
					)
				)
		end
		
		def self.success?(response)
			# puts response
			response.inspect['status'] == 'success'
		end
	
end