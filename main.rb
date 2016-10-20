#!/usr/bin/env ruby

require "logger"

log = Logger.new("/tmp/configure.log")


hostname = `hostname`.strip
api_key  = ENV['API_KEY']

server_type = case
  when hostname[/app/]
    'app'
  when hostname[/db/]
    'db'
  when hostname[/lb/]
    'loadbalancer'
  else
    log.error("Invalid hostname")
  end
  
application_type = case ENV['APPLICATION']
  when 'parse'
    'parse'
  else
    log.error("Unknown Application")
  end
  
log.info("#{server_type} #{application_type}")
   
