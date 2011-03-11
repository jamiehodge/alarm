require 'sinatra/base'
require './lib/sinatra/sessionauth'

class App < Sinatra::Base
	register Sinatra::R18n
	register Sinatra::SessionAuth
	
	mime_type :otf, 'font/otf'
	mime_type :ttf, 'font/ttf'
	mime_type :eot, 'application/vnd.ms-fontobject'
	mime_type :svg, 'image/svg+xml'

	configure do
		set :app_file, __FILE__
		
		YAML.load_file(File.expand_path('settings.yml')).each_pair { |k,v| set k.to_sym, v }

		Compass.configuration do |config|
	    config.css_dir = 'css'
			config.output_style = production? ? :compressed : :expanded
	  end

		Mongoid.configure { |c| c.from_hash mongoid }

		Rakismet.key = rakismet['key']
		Rakismet.url = rakismet['url']
		Rakismet.host = rakismet['host']

		set :haml, { :format => :html5 }
		set :sass, Compass.sass_engine_options
	end

	configure(:development) {require 'sinatra/reloader'}

	$LOAD_PATH.unshift File.join(root, 'lib' )
	require 'atom'
	require 'comment'
	
	helpers do

		def library_root
			@library_root ||= Atom::Catalog.with_uri("#{settings.pcp['library']}/catalogs")
		end
		
		def catalogs
			@catalogs ||= library_root.entries.select { |catalog| settings.pcp['catalogs'].include? "#{catalog.alternate_link['feedtype'].gsub(/_feeds_catalog/, '')}" }
		end

	end
	
	# Assets
	
	get '/css/:name.css' do |name|
		content_type 'text/css', :charset => 'utf-8'
		sass :"sass/#{name}"
	end
	
	# Library

	get '/catalogs/:id' do
		haml :'catalogs/show', 
			:layout => :'layouts/app', 
			:locals => { :catalog => Atom::Catalog.with_uri("#{settings.pcp['library']}/catalogs/#{params[:id]}")}
	end

	get '/feeds/:feed_id/episodes/:episode_id' do
		feed = Atom::Feed.with_uri("#{settings.pcp['library']}/atom_feeds/#{params[:feed_id]}")
		haml :'episodes/show',
			:layout => :'layouts/app',
			:locals => { :feed => feed, :episode => feed.entry(params[:episode_id])}
	end
	
	post '/feeds/:feed_id/episodes/:episode_id/comments' do
		comment = Comment.new(
			params.merge(
				:published => Time.now,
				:user_ip => request.ip,
				:user_agent => request.user_agent,
				:referrer => request.referrer,
				:feed_id => params[:feed_id],
				:episode_id => params[:episode_id]
		))
		comment.save unless comment.spam?
		redirect request.referer 
	end

	get '/feeds/:id' do
		haml :'feeds/show', 
			:layout => :'layouts/app', 
			:locals => { :feed => Atom::Feed.with_uri("#{settings.pcp['library']}/atom_feeds/#{params[:id]}")}
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
	
	# Root
	
	get '/' do
		redirect "/catalogs/#{settings.pcp['recent']}"
	end

end