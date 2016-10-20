module Installer
  class Parse
    def initialize(role, application_repo)
      @role = role
      @application_repo = application_repo
    end
    
    attr_reader :role, :application_repo
    
    def configure!
      if role == 'db'
        configure_database
      elsif role == 'app'
        configure_app
      end
    end
    
    def configure_database
     system("sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && echo \"deb http://repo.mongodb.org/apt/ubuntu \"$(lsb_release -sc)\"/mongodb-org/3.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list")
     system("apt-get update && apt-get install -y mongodb-org")
    end
    
    def configure_app
      system("curl -sL https://deb.nodesource.com/setup_5.x | bash")
      system("apt-get install -y nodejs build-essential git")
      
      if application_repo
        system("git clone #{application_repo}")
      end
    end
  end
end
