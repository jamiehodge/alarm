module Atom
	class Episode
		include Atom

		elements 'title', 'summary', 'author/name', 'author/email', 'itunes|explicit', 'itunes|keywords'
		time_elements 'published', 'updated'
		link 'related'
		links 'enclosure'

		def video_links
			@video_links ||= begin
				links = enclosure_links.select { |e| e['type'].split('/').first == 'video' }
				links.empty? ? nil : links
			end
		end

		def audio_links
			@audio_links ||= begin
				links = enclosure_links.select { |e| e['type'].split('/').first == 'audio' }
				links.empty? ? nil : links
			end
		end

	end
end