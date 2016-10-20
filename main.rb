#!/usr/bin/env ruby

require "logger"

log = Logger.new("/tmp/configure.log")

hostname = `hostname`.strip

server_type = case
  when hostname[/app/]
    'app'
  when hostname[/db/]
    'db'
  when hostname[/lb/]
    'loadbalancer'
  else
    raise StandardError, "Invalid hostname"
  end
  
application_type = case ENV['application']
  when 'parse'
    'parse'
  else
    raise StandardError, "Unknown Application"
  end
  
log.info("#{server_type} #{application_type}")
   
