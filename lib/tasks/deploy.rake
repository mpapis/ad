require "command-designer"
require "remote-exec"

class Deploy < CommandDesigner::Dsl
  attr_accessor :server, :path, :repo

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
    run(:mkdir, "-p", cache)
  end

  def download_code
    command_prefix(:cd, cache) do
      if   run(:test, "-d", ".git")
      then run(:git, "pull")
      else run(:git, "clone", repo, ".")
      end
    end
  end

  def link_code
  end

  def migrate_db
  end

private

  def cache
    @cache ||= File.join(path, "cache")
  end

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

  def command_prefix(code, *params, &block)
    options = Hash === params.last ? params.pop : {}
    options[:separator] ||= options[:s] || "&&"
    cmd_prefix = command(code, *params)
    local_filter(
      Proc.new { |cmd|
        "#{cmd_prefix} #{options[:separator]} #{cmd}"
      },
      &block
    )
  end

end

desc "Put app on a server"
task :deploy do
  Deploy.new do |deployer|
    deployer.server = RemoteExec::Local.new
    deployer.path   = "/dev/shm/my_app"
    deployer.repo   = "https://github.com/mpapis/ad.git"
    deployer.deploy
  end
end
