require "command-designer"
require "remote-exec"

class Deploy < CommandDesigner::Dsl
  attr_accessor :server, :path

  def initialize
    super([:first, nil, :last])
    yield self
  end

  def deploy
    validate
    prepare_system
    download_code
    link_code
    migrate_db
  end

  def validate
    raise "no path given" if path.nil?
    raise "no server given" if server.nil?
  end

  def prepare_system
    run(:mkdir, "-p", path)
  end

  def download_code
  end

  def link_code
  end

  def migrate_db
  end

private

  def run(*params)
    cmd = command(*params)
    puts "Executing: #{cmd}"
    status = server.execute(cmd)
    if status == 0
    then puts "Success"
    else puts "Failed(#{status})"
    end
    return status == 0
  end

end

desc "Put app on a server"
task :deploy do
  Deploy.new do |deployer|
    deployer.server = RemoteExec::Local.new
    deployer.path   = "/dev/shm/my_app"
    deployer.deploy
  end
end
