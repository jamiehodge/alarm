class App < Sinatra::Base
	
	get '/feeds/:id' do
		haml :'feeds/show', 
			:layout => :'layouts/app', 
			:locals => { :feed => Atom::Feed.with_uri("#{settings.pcp['library']}/atom_feeds/#{params[:id]}")}
	end

	put '/feeds/:id' do
		authenticate!
		PodcastProducer::Server.set_feed_property(params[:id], params[:property_name], params[:property_value])
	end

	get '/feeds/:id/edit' do
		authenticate!
		session[:return_to] = request.path_info
		haml :'feeds/edit',
		:layout => :'layouts/app',
		:locals => { :feed => Atom::Feed.with_uri("#{settings.pcp['library']}/atom_feeds/#{params[:id]}")}
	end

	put '/feeds/:id/image' do
		authenticate!
		PodcastProducer::Server.set_image('feed', params[:id], IO.read(params[:file][:tempfile]), File.extname(params[:file][:filename]))
		redirect session[:return_to]
	end

	get '/keywords/:id' do
		haml :'feeds/show',
			:layout => :'layouts/app',
			:locals => { :feed => Atom::Feed.with_uri("#{settings.pcp['library']}/keyword_atom_feeds/#{params[:id]}")}
	end

	get '/users/:id' do
		haml :'feeds/show',
		:layout => :'layouts/app',
		:locals => { :feed => Atom::Feed.with_uri("#{settings.pcp['library']}/user_atom_feeds/#{params[:id]}")}
	end

	get '/users/:id/edit' do
		authenticate!
		session[:return_to] = "/users/#{params[:id]}/edit"
		haml :'feeds/edit',
		:layout => :'layouts/app',
		:locals => { :feed => Atom::Feed.with_uri("#{settings.pcp['library']}/user_atom_feeds/#{params[:id]}")}
	end
	
end