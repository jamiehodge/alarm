module Atom
	class Entry
		include Atom

		elements 'title', 'summary', 'author/name', 'author/email', 'itunes|explicit'
		time_elements 'published', 'updated'
		link 'related', 'alternate'
	end
end