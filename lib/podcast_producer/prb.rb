module PodcastProducer
	class PRB
		
		attr_reader :uuid
		
		def initialize(uuid)
			@base = "#{App.settings.pcp['library_path']}/UUIDs/#{uuid}.prb"
			@uuid = uuid
		end
		
		def set_property(property_name, property_value)
			properties.send("#{property_name}=".to_sym, property_value)
		end
		
		def properties
			@plist ||= PodcastProducer::Properties.new(@base + '/Contents/Resources/Metadata/properties.plist')
		end
		
		def attachments
			@attachments ||= Dir.glob(@base + '/Contents/Resources/Published/*.ppi').map { |path| PodcastProducer::PPI.new(path) }
		end
		
		def synchronize
			responses = []
			attachments.each do |attachment|
				responses << PodcastProducer::Server.synchronize(uuid, attachment.uuid)
			end
			responses.all?
		end
	end
end