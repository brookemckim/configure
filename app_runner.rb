require 'droplet_kit'

class AppRunner
  def initialize(path, command)
    @path    = path
    @command = command
  end
  
  attr_reader :path, :command
  
  def run!
    fork do
      exec("cd #{path} && DATABASE_URI=#{primary_database_server.public_ip} #{command}")
    end
  end
  
  def cluster_tag
    tags = `curl http://169.254.169.254/metadata/v1/tags/`.split("\n")
    tags.find { |tag| tag['cluster-'] }
  end
  
  def servers_in_cluster
    @_servers_in_cluster ||= $client.droplets.all(tag_name: cluster_tag)
  end
  
  def database_servers
    servers_in_cluster.select { |server|
      server.name['db']
    }
  end
  
  def primary_database_server
    database_servers.find { |server|
      server.name['01']
    }
  end
end
