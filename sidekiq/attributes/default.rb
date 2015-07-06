node[:deploy].each do |application, deploy|
  # default[:deploy][application][:sidekiq][:queues]      = ['default']
  # default[:deploy][application][:sidekiq][:concurrency] = '10'
  default[:deploy][application][:sidekiq][:start_command] = "bundle exec sidekiq --daemon --environment #{deploy[:rails_env]} --pidfile #{deploy[:deploy_to]}/shared/pids/sidekiq.pid --logfile #{deploy[:deploy_to]}/shared/log/sidekiq.log -q image_processing -q default -q cache_warming --concurrency 10"
end

# default['sidekiq']['queues']      = ['default']
# default['sidekiq']['concurrency'] = 10
