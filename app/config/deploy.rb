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

ssh_options[:forward_agent] = true

before 'deploy:create_symlink', 'deploy:install_assets'

after "deploy",           "deploy:set_perms_cache_logs"
after "deploy",           "deploy:cleanup"

namespace :deploy do
  task :install_assets, :roles => :app do
      run "cd #{release_path} && php app/console assets:install --env=prod --symlink"
      run "cd #{release_path} && php app/console assetic:dump --env=prod --no-debug"
      run "cd #{release_path} && php app/console cache:clear --env=prod"
      run "cd #{release_path} && php app/console cache:warmup --env=prod"
      run "cd #{release_path} && php app/console doctrine:schema:update --force"
  end

  task :set_perms_cache_logs, :roles => :app do
    transfer :up, "web/app_dev.php", "/home/jedibee/processezy.com/current/web/devaccess.php"
  end
end