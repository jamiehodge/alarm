class App < Sinatra::Base
	
	get '/catalogs/:id' do
		catalog = open_resource("#{settings.pcp['library']}/catalogs/#{params[:id]}")
		etag catalog.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		haml :'catalogs/show', 
			:layout => :'layouts/app', 
			:locals => { :catalog => Atom::Catalog.parse(catalog)}
	end

	put '/catalogs/:id' do
		authenticate!
		PodcastProducer::Server.set_catalog_property(params[:id], params[:property_name], params[:property_value])
	end

	get '/catalogs/:id/edit' do
		authenticate!
		catalog = open_resource("#{settings.pcp['library']}/catalogs/#{params[:id]}")
		etag catalog.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		session[:return_to] = request.path_info
		haml :'catalogs/edit',
		:layout => :'layouts/app',
		:locals => { :catalog => Atom::Feed.parse(catalog)}
	end

	put '/catalogs/:id/image' do
		authenticate!
		PodcastProducer::Server.set_image('catalog', params[:id], IO.read(params[:file][:tempfile]), File.extname(params[:file][:filename]))
		redirect session[:return_to]
	end
	
end