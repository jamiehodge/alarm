# encoding: UTF-8

class App < Sinatra::Base
  register Sinatra::R18n
  helpers Sinatra::UrlForHelper
  
  mime_type :otf, 'application/octet-stream'
  mime_type :ttf, 'application/octet-stream'
  
  configure do
    set :app_file, __FILE__
    
    config_file = YAML.load_file File.join('conf', 'settings.yml')
    config_file.each_pair { |k,v| set k.to_sym, v }
    
    Compass.configuration do |config|
      config.project_path = root
      config.environment = environment
      config.output_style = :compressed
      config.css_dir = 'stylesheets'
      config.images_dir = 'images'
    end
    
    set :haml, { :format => :html5 }
    set :sass, Compass.sass_engine_options
    
    Mongoid.configure do |config|
      name = "#{title.split.join('_').downcase}_#{environment}"
      host = 'localhost'
      config.master = Mongo::Connection.new.db(name)
      config.slaves = [
        Mongo::Connection.new(host, 27017, :slave_ok => true).db(name)
      ]
      config.persist_in_safe_mode = false
    end
    
    Rakismet.key = akismet_key
    Rakismet.url = akismet_url
    Rakismet.host = 'rest.akismet.com'
    
    enable :sessions
  end
  
  $LOAD_PATH.unshift File.join(root, 'lib' )
  require 'atom'
  require 'comment'
  
  helpers do
    include Rack::Utils
    
    def root_catalog
      @root_catalog ||= Atom::Feed.with_uri("#{settings.base_url}/catalogs")
    end
    
    def home_feed
      Atom::Feed.with_uri("#{settings.base_url}/atom_feeds/#{settings.home_feed}")
    end
    
    def latest_feed
      Atom::Feed.with_uri("#{settings.base_url}/atom_feeds/#{settings.latest_feed}")
    end
    
    def cache_page(seconds=5*60)
      response['Cache-Control'] = "public, max-age=#{seconds}" unless development?
    end
    
  end
  
  before do
    session[:locale] = params[:locale] if params[:locale]
  end
  
  get '/stylesheets/:name.css' do |name|
    cache_page
    content_type 'text/css', :charset => 'utf-8'
    sass :"sass/#{name}"
  end
  
  get '/:feed_type/:id' do
    cache_page
    @feed = Atom::Feed.with_uri("#{settings.base_url}/#{params[:feed_type]}/#{params[:id]}")
    halt 404 unless @feed && root_catalog && latest_feed
    @title = "Alarm: #{@feed.title}"
    if @feed.catalog?
      haml :catalog, :locals => { :feed => @feed, :root => root_catalog, :latest => latest_feed }
    else
      haml :feed, :locals => { :feed => @feed, :root => root_catalog, :latest => latest_feed }
    end
  end
  
  post '/comments' do
    @comment = Comment.new(params.merge(:created_at => Time.now, :user_ip => request.ip, :user_agent => request.user_agent, :referrer => request.referer))
    @comment.save unless @comment.spam?
    redirect request.referer + "##{params[:entry_id]}"
  end
  
  get '/' do
    redirect url_for("/atom_feeds/#{home_feed.id}")
  end
end