set :application, "testing"
set :deploy_to,   "/home/deploy/testing"
set :app_path,    "app"
set :user, "deploy"
set :password, "paroladeploy"
default_run_options[:pty] = true
set :interactive_mode, false

set   :use_sudo,          false

set :git_https_username, 'iliegurzun'
set :git_https_password, 'parola'

set :pty, true

set :format, :pretty

ssh_options[:forward_agent] = true
#ssh_options[:use_agent] = false
#ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

set :domain,      "127.0.0.1"
set :branch, 	  "master"

set   :scm,               :git
set   :repository,        "https://github.com/iliegurzun/project.git"

role  :web,               domain
role  :app,               domain
role  :db,                domain, :primary => true

set   :keep_releases,     3

set   :deploy_via,        :remote_cache
set :composer_options,  "--optimize-autoloader"

# Assets install path
set :assets_install_path,   fetch(:web_path)

# Assets install flags
set :assets_install_flags,  '--symlink'

set :dump_assetic_assets, true

# Assetic dump flags
set :assetic_dump_flags,  '--env=prod --no-debug'

set   :shared_files,      ["app/config/parameters.yml"]
set   :shared_children,   [app_path + "/logs", web_path + "/uploads", "vendor"]
set   :use_composer,      true
set   :update_vendors,    false

logger.level = Logger::MAX_LEVEL

after 'symfony:cache:warmup',   'deploy:phpunit'

# permissions
set :writable_dirs, ["app/cache", "app/logs"]
set :webserver_user, "www-data"
set :permission_method, :acl
set :use_set_permissions, false

namespace :deploy do
	task :phpunit, :roles => :app do
		run "cd #{release_path} && phpunit --verbose --debug -c app/ --coverage-clover=#{deploy_to}/releases/clover.xml"
		run "cd #{release_path} && php app/console app.code_coverage --file=#{deploy_to}/releases/clover.xml"
	end
end