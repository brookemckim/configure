require 'droplet_kit'

class AppRunner
  def initialize(path, command)
    @path    = path
    @command = command
  end
  
  attr_reader :path, :command
  
  def run!
    ip = get_database_ip(cluster_tag)
  end
  
  def cluster_tag
    tags = `curl http://169.254.169.254/metadata/v1/tags/`.split("\n")
    tags.find { |tag| tag['cluster-'] }
  end
  
private
  
  def get_database_ip(tag)
    $log.info("Cluster Tag: #{tag}")
  end
end
