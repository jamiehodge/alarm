class App < Sinatra::Base
	
	get '/catalog/:id' do
		catalog = open_resource("#{settings.pcp['library']}/catalogs/#{params[:id]}")
		etag catalog.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_catalog = Atom::Catalog.parse(catalog)
		@title = "#{settings.site['title']}: #{parsed_catalog.title}"
		haml :'catalogs/show', 
			:layout => :'layouts/app', 
			:locals => { :catalog => parsed_catalog}
	end

	put '/catalog/:id' do
		authenticate!
		PodcastProducer::Server.set_catalog_property(params[:id], params[:property_name], params[:property_value])
	end

	get '/catalog/:id/edit' do
		authenticate!
		catalog = open_resource("#{settings.pcp['library']}/catalogs/#{params[:id]}")
		etag catalog.meta['etag'].gsub(/"/, '') unless flash.has?(:notice) || flash.has?(:error)
		parsed_catalog = Atom::Catalog.parse(catalog)
		@title = "#{settings.site['title']}: #{parsed_catalog.title}"
		session[:return_to] = request.path_info
		haml :'catalogs/edit',
		:layout => :'layouts/app',
		:locals => { :catalog => parsed_catalog}
	end

	put '/catalog/:id/image' do
		authenticate!
		PodcastProducer::Server.set_image('catalog', params[:id], IO.read(params[:file][:tempfile]), File.extname(params[:file][:filename]))
		redirect session[:return_to]
	end
	
end