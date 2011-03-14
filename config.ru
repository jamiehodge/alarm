require 'rubygems'
require 'bundler'
Bundler.require

require 'open-uri'
require 'yaml'
require 'base64'

require './app'

use Rack::Session::Cookie, :secret => `uuidgen`
use Rack::MethodOverride
use Rack::Flash
	
map '/' do
	run App
end