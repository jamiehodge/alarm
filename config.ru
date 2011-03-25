require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

require 'open-uri'
require 'yaml'
require 'base64'

use Rack::Session::Cookie, :secret => `uuidgen`
use Rack::Flash
use Rack::MethodOverride

=begin
use Rack::Cache,
  :verbose     => true,
  :metastore   => 'file:cache/meta',
  :entitystore => 'file:cache/body'
=end
	
require './app'

map '/' do
	run App
end