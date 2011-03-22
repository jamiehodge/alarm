require 'sinatra/base'
require './lib/sinatra/sessionauth'

class App < Sinatra::Base
	register Sinatra::R18n
	register Sinatra::SessionAuth
	# use Rack::SslEnforcer, :only => "/login", :strict => true

	mime_type :otf, 'font/otf'
	mime_type :ttf, 'font/ttf'
	mime_type :eot, 'application/vnd.ms-fontobject'
	mime_type :svg, 'image/svg+xml'

	configure do
		set :app_file, __FILE__
		
		YAML.load_file(File.expand_path('settings.yml')).each_pair { |k,v| set k.to_sym, v }

		Mongoid.configure { |c| c.from_hash mongoid }

		Rakismet.key = rakismet['key']
		Rakismet.url = rakismet['url']
		Rakismet.host = rakismet['host']

		set :haml, { :format => :html5 }
	end
	
	configure(:development) do
		register Sinatra::Reloader
		also_reload "routes/*.rb"
		
		Compass.configuration do |config|
	    config.css_dir = 'css'
			config.images_dir = 'img'
			config.output_style = :compressed
	  end
	
		set :sass, Compass.sass_engine_options
	end

	$LOAD_PATH.unshift File.join(root, 'lib')
	require 'atom'
	require 'comment'
	require 'podcast_producer'
	
	helpers do
		include Rack::Utils
		alias_method :h, :escape_html

		def library_root
			@library_root ||= Atom::Catalog.with_uri("#{settings.pcp['library']}/catalogs")
		end
		
		def catalogs
			@catalogs ||= library_root.entries.select { |catalog| settings.pcp['catalogs'].include? "#{catalog.alternate_link['feedtype'].gsub(/_feeds_catalog/, '')}" }
		end
		
		def base_url
			@base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
		end

	end
	
	require_relative 'routes/catalogs'
	require_relative 'routes/feeds'
	require_relative 'routes/episodes'
	
	before do
		session[:locale] = params[:locale] if params[:locale]
	end
	
	get '/css/:name.css' do |name|
		content_type 'text/css', :charset => 'utf-8'
		sass :"sass/#{name}"
	end
	
	get '/' do
		redirect "/feeds/#{settings.pcp['recent']}"
	end

end