#!/usr/bin/env ruby

require "logger"
require_relative "parse"

$log = Logger.new("/tmp/configure.log")

File.readlines("/etc/environment").each do |line|
  key, value = line.chomp.split "="
  ENV[key] = value
end

api_key           = ENV['API_KEY']
application_repo  = ENV['APPLICATION_REPO']

$hostname         = `hostname`.strip
$client           = DropletKit::Client.new(access_token: api_key)

server_type = case
  when $hostname[/app/]
    'app'
  when $hostname[/db/]
    'db'
  when $hostname[/lb/]
    'loadbalancer'
  else
    $log.error("Invalid hostname")
  end
  
application_type = case ENV['APPLICATION']
  when 'parse'
    'parse'
  else
    log.error("Unknown Application")
  end
  
$log.info("#{server_type} #{application_type}")


if application_type == 'parse'
  Installer::Parse.new(server_type, application_repo).configure!
else
  # noop
end
