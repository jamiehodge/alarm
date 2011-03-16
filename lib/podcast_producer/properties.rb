module PodcastProducer
	class Properties
		
		attr_reader :properties
		
		def initialize(path)
			@path = path
			@properties = ::Plist::parse_xml(path)
		end
		
		def title
			properties['Title']
		end
		
		def title=(value)
			properties['Title'] = value
			self
		end
		
		def description
			properties['Description']
		end
		
		def description=(value)
			properties['Description'] = value
			self
		end
		
		def to_plist
			properties.to_plist
		end
		
		def save
			File.open(@path, 'w') { |file| file.write(properties.to_plist )}
		end
		
	end
end