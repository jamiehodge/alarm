module Atom
	class Catalog
		include Atom

		elements 'title', 'subtitle', 'author/name', 'author/email'
		elements 'logo', 'icon', 'rights', 'generator'
		time_element 'updated'
		link 'self', 'alternate', 'root'
		entries 'entry'
		
	end
end