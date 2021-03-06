module Atom
	class Feed
		include Atom

		elements 'title', 'subtitle', 'author/name', 'author/email'
		elements 'logo', 'icon', 'rights', 'generator', 'itunes|explicit' # itunes|image
		time_element 'updated'
		link 'self', 'alternate', 'root'
		entries 'episode'
		
	end
end