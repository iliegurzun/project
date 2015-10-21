set :application, "testing"
set :deploy_to,   "/var/www"
set :app_path,    "app"
set :user, "dev"
set :password, "paroladev"

set   :use_sudo,          false

set :git_https_username, 'iliegurzun'
set :git_https_password, 'parola'

set :ssh_options, :forward_agent => true

set :domain,      "127.0.0.1:3022"
set :branch, 	  "master"

set   :scm,               :git
set   :repository,        "https://github.com/iliegurzun/project.git"

role  :web,               domain
role  :app,               domain
role  :db,                domain, :primary => true

set   :keep_releases,     3

#set   :deploy_via,        :remote_cache

set   :shared_files,      ["app/config/parameters.yml"]
set   :shared_children,   [app_path + "/logs", web_path + "/uploads", "vendor"]
set   :use_composer,      true
set   :update_vendors,    false

logger.level = Logger::MAX_LEVEL

before 'deploy:create_symlink', 'deploy:install_assets'

after "deploy",           "deploy:set_perms_cache_logs"
after "deploy",           "deploy:cleanup"

# permissions
set :writable_dirs, ["app/cache", "app/logs"]
set :webserver_user, "www-data"
set :permission_method, :acl
set :use_set_permissions, false