require 'rubygems'
require 'sinatra/base'

set :env, :production
disable :run

require File.expand_path '../app.rb', __FILE__

run App