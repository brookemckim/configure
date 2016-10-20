require_relative 'app_runner'

module Installer
  class Parse
    def initialize(role, application_repo)
      @role               = role
      @application_repo   = application_repo
      @application_folder = "/opt/" + application_repo.split("/").last
    end
    
    attr_reader :role, :application_repo, :application_folder
    
    def configure!
      if role == 'db'
        install_database
        setup_database
      elsif role == 'app'
        install_app
        setup_app
        run_app
      end
    end
    
    def install_database
     system("sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && echo \"deb http://repo.mongodb.org/apt/ubuntu \"$(lsb_release -sc)\"/mongodb-org/3.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list")
     system("apt-get update && apt-get install -y mongodb-org")
    end
    
    def setup_database
      system("sed -i -e 's|bindIp: 127.0.0.1|bindIp: 0.0.0.0|g' /etc/mongod.conf")
    end
    
    def install_app
      system("curl -sL https://deb.nodesource.com/setup_5.x | bash")
      system("apt-get install -y nodejs build-essential git")
    end
    
    def setup_app
      if application_repo
        system("cd /opt && git clone #{application_repo}")
        system("cd #{application_folder} && npm install")
      end
    end
    
    def run_app
      AppRunner.new(application_folder, "npm start").start!
    end
  end
end
