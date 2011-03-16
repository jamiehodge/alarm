module PodcastProducer
	class PPI
		
		attr_reader :properties
		
		def initialize(path)
			@path = path
			@properties = Plist::parse_xml(path)
		end
		
		def uuid
			properties['uuid']
		end
		
		def to_plist
			properties.to_plist
		end
		
		def save
			File.open(@path, 'w') { |file| file.write(properties.to_plist )}
		end
		
	end
end