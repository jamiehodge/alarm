# encoding: UTF-8

class App < Sinatra::Base
  
  configure do
    Compass.add_project_configuration(File.join(File.dirname(__FILE__), 'config.rb'))
    
    DB = Sequel.sqlite(File.join(File.dirname(__FILE__), 'db', 'alarm.db'))
    
    Rakismet.key = ''
    Rakismet.url = 'http://larm-radio.hum.ku.dk'
    Rakismet.host = 'rest.akismet.com'
  end
  
  $LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib' )
  require 'atom'
  require 'comment'
  
  helpers do
    include Rack::Utils
    
    def base_url
      "http://larm-radio.hum.ku.dk/podcastproducer" # change to reflect your installation
    end
    
    def root_catalog
      @root_catalog ||= Atom::Feed.with_uri("#{base_url}/catalogs")
    end
    
    def keywords_catalog
      @keywords_catalog ||= root_catalog.entries.find { |e| e.link('alternate')['feedtype'] == "keyword_feeds_catalog" }
    end
  end
  
  get '/stylesheets/:name.css' do |name|
    content_type 'text/css', charset: 'utf-8'
    sass :"stylesheets/#{name}", Compass.sass_engine_options
  end
  
  get '/:feed_type/?:id?' do
    @feed = Atom::Feed.with_uri("#{base_url}/#{params[:feed_type]}/#{params[:id]}")
    halt 404 unless @feed && root_catalog
    @title = "Alarm: #{@feed.title}"
    haml :feed, locals: { feed: @feed, root: root_catalog }
  end
  
  post '/comments' do
    @comment = Comment.new(params.merge(created_at: Time.now, user_ip: request.ip, user_agent: request.user_agent, referrer: request.referer))
    @comment.save unless @comment.spam?
    redirect request.referer + "##{params[:entry_id]}"
  end
  
  get '/' do
    redirect "/catalogs/#{keywords_catalog.id}"
  end
end