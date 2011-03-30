class App < Sinatra::Base
	
	get '/feed/:id' do
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:id]}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.title}"
		haml :'feeds/show', 
			:layout => :'layouts/app', 
			:locals => { :feed => parsed_feed}
	end

	put '/feed/:id' do
		authenticate!
		PodcastProducer::Server.set_feed_property(params[:id], params[:property_name], params[:property_value])
	end

	get '/feed/:id/edit' do
		authenticate!
		feed = open_resource("#{settings.pcp['library']}/atom_feeds/#{params[:id]}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.title}"
		session[:return_to] = request.path_info
		haml :'feeds/edit',
		:layout => :'layouts/app',
		:locals => { :feed => parsed_feed}
	end

	put '/feed/:id/image' do
		authenticate!
		PodcastProducer::Server.set_image('feed', params[:id], IO.read(params[:file][:tempfile]), File.extname(params[:file][:filename]))
		redirect session[:return_to]
	end

	get '/keyword/:id' do
		feed = open_resource("#{settings.pcp['library']}/keyword_atom_feeds/#{URI.encode(params[:id])}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.title}"
		haml :'feeds/show',
			:layout => :'layouts/app',
			:locals => { :feed => parsed_feed}
	end

	get '/user/:id' do
		feed = open_resource("#{settings.pcp['library']}/user_atom_feeds/#{URI.encode(params[:id])}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.title}"
		haml :'feeds/show',
		:layout => :'layouts/app',
		:locals => { :feed => parsed_feed}
	end

	get '/user/:id/edit' do
		authenticate!
		feed = open_resource("#{settings.pcp['library']}/user_atom_feeds/#{params[:id]}")
		etag feed.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_feed = Atom::Feed.parse(feed)
		@title = "#{settings.site['title']}: #{parsed_feed.title}"
		session[:return_to] = "/user/#{params[:id]}/edit"
		haml :'feeds/edit',
		:layout => :'layouts/app',
		:locals => { :feed => parsed_feed}
	end
	
end