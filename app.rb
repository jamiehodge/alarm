# encoding: UTF-8

class App < Sinatra::Base
  register Sinatra::R18n
  helpers Sinatra::UrlForHelper
  
  mime_type :otf, 'application/octet-stream'
  mime_type :ttf, 'application/octet-stream'
  
  configure do
    set :app_file, __FILE__
    set :base_url, 'http://larm-radio.hum.ku.dk/podcastproducer'
    set :home_catalog, '130D80EB-2C3B-49D4-91E2-11CD100F9EAC'
    set :latest_feed, '130D80EB-2C3B-49D4-91E2-11CD100F9EAC'
    
    Compass.configuration do |config|
      config.project_path = File.dirname(__FILE__)
      config.sass_dir = 'view/stylesheets'
      config.output_style = :compressed
    end
    
    set :haml, { :format => :html5 }
    set :sass, Compass.sass_engine_options
    
    Mongoid.configure do |config|
      name = "#{environment}"
      host = 'localhost'
      config.master = Mongo::Connection.new.db(name)
      config.slaves = [
        Mongo::Connection.new(host, 27017, :slave_ok => true).db(name)
      ]
      config.persist_in_safe_mode = false
    end
    
    Rakismet.key = ''
    Rakismet.url = 'http://larm-radio.hum.ku.dk'
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
    
    def home_catalog
      @home_catalog ||= Atom::Feed.with_uri("#{settings.base_url}/atom_feeds/#{settings.home_catalog}")
    end
    
    def latest_feed
      @latest_feed ||= Atom::Feed.with_uri("#{settings.base_url}/atom_feeds/#{settings.latest_feed}")
    end
    
    def cache_page(seconds=5*60)
      response['Cache-Control'] = "public, max-age=#{seconds}" unless development?
    end
    
  end
  
  before do
    session[:locale] = 'da'
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
    redirect url_for("/atom_feeds/#{home_catalog.id}")
  end
end