# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'bibliotekskort'
set :repo_url, 'https://github.com/ub-digit/bibliotekskort.git'

set :rvm_ruby_version, '2.3.1'      # Defaults to: 'default'

# Returns config for current stage assigned in config/deploy.yml
def deploy_config
  @config ||= YAML.load_file("config/deploy.yml")
  stage = fetch(:stage)
  return @config[stage.to_s]
end

# Copied into /{app}/shared/config from respective sample file
set :linked_files , %w{config/database.yml config/config_secret.yml}

server deploy_config['host'], user: deploy_config['user'], roles: ['app', 'db', 'web'], port: deploy_config['port']

set :deploy_to, deploy_config['path']

after "deploy:finishing", "extra_cmds:create_version_file"

set :default_env, {
    "PATH" => deploy_config['nvm_path'] + ":$PATH"
}
