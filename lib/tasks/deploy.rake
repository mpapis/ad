require "command-designer"
require "remote-exec"

class Deploy
  def initialize
  end
  def deploy
    puts "not yet"
  end
end

desc "Put app on a server"
task :deploy do
  Deploy.new.deploy
end
