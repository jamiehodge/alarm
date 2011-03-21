require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

require 'open-uri'
require 'yaml'
require 'base64'

use Rack::Session::Cookie, :secret => `uuidgen`
use Rack::Flash
use Rack::MethodOverride

require './app'

map '/' do
	run App
end