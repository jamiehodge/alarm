# encoding: UTF-8

class App < Sinatra::Base
  
  mime_type :otf, 'application/octet-stream'
  mime_type :ttf, 'application/octet-stream'
  
  configure do
    set :app_file, __FILE__
    set :base_url, 'http://larm-radio.hum.ku.dk/podcastproducer'
    set :home_catalog, 'E70D82E2-08B0-4A50-9E02-8547D8135F13'
    set :latest_feed, '8D48DE8C-94CC-4B4B-8E8F-F9723154BC27' # 'F43EC952-9436-4DDA-A173-5DAE02924CC1'
    
    Compass.configuration.project_path = public
    Compass.configuration.environment = environment
    Compass.configuration.output_style = :compressed
    
    Sequel.sqlite(File.join(root, 'db', "#{environment}.db"))
    
    Rakismet.key = ''
    Rakismet.url = 'http://larm-radio.hum.ku.dk'
    Rakismet.host = 'rest.akismet.com'
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
    
    
  end
  
  get '/css/:name.css' do |name|
    content_type 'text/css', charset: 'utf-8'
    sass :"sass/#{name}", Compass.sass_engine_options
  end
  
  get '/:feed_type/:id' do
    @feed = Atom::Feed.with_uri("#{settings.base_url}/#{params[:feed_type]}/#{params[:id]}")
    halt 404 unless @feed && root_catalog && latest_feed
    @title = "Alarm: #{@feed.title}"
    if @feed.catalog?
      haml :catalog, locals: { feed: @feed, root: root_catalog, latest: latest_feed }
    else
      haml :feed, locals: { feed: @feed, root: root_catalog, latest: latest_feed }
    end
  end
  
  post '/comments' do
    @comment = Comment.new(params.merge(created_at: Time.now, user_ip: request.ip, user_agent: request.user_agent, referrer: request.referer))
    @comment.save unless @comment.spam?
    redirect request.referer + "##{params[:entry_id]}"
  end
  
  get '/' do
    redirect "/atom_feeds/#{home_catalog.id}"
  end
end