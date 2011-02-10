# encoding: UTF-8

require 'rubygems'
require 'bundler'

Bundler.require
Bundler.require(:development) if development?

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

require './app.rb'
run App