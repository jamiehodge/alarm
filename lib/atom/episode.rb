module Atom
	class Episode
		include Atom

		elements 'title', 'summary', 'author/name', 'author/email', 'itunes|explicit', 'itunes|keywords'
		time_elements 'published', 'updated'
		link 'related'
		links 'enclosure'
		
		def comments
			Comment.find(:conditions => { :episode_id => uuid } ).order_by(:created_at)
		end
	end
end