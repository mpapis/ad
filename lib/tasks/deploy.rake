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
    copy_code
    link_code
    migrate_db
  end

  def validate
    raise("no path given")   if path.nil?
    raise("no server given") if server.nil?
  end

  def prepare_system
    run(:mkdir, "-p", path) &&
    run(:mkdir, "-p", releases) &&
    run(:mkdir, "-p", temporary) ||
      raise("can not create target directories")
  end

  def download_code
    if
      run(:test, "-d", cache)
    then
      run(:git, "--git-dir", cache, "fetch") ||
        raise("can not update sources")
    else
      run(:git, "clone", "--bare", repo, cache) ||
        raise("can not download sources")
    end
  end

  def copy_code
    run(:mkdir, "-p", release) ||
      raise("can not create release directory")
    run(:git, "--git-dir", cache, "--work-tree", release, "checkout", "--", "*") ||
      raise("can not copy sources")
  end

  def link_code
    run(:ln, "-nsfT", release, current)
  end

  def migrate_db
  end

private

  def cache
    @cache ||= File.join(path, "cache.git")
  end

  def temporary
    @temporary ||= File.join(path, "tmp")
  end

  def release_marker
    @release_marker ||= Time.now.utc.strftime("%Y%m%d_%H%M%S_%N")
  end

  def releases
    @releases ||= File.join(path, "releases")
  end

  def release
    @release ||= File.join(releases, release_marker)
  end

  def current
    @current ||= File.join(path, "current")
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
