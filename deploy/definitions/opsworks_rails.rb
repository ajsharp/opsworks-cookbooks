define :opsworks_rails do
  deploy = params[:deploy_data]
  application = params[:app]

  include_recipe node[:opsworks][:rails_stack][:recipe]


  # write out memcached.yml
  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    cookbook "rails"
    source "memcached.yml.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => (deploy[:memcached] || {}), :environment => deploy[:rails_env])

    only_if do
      deploy[:memcached][:host].present?
    end
  end

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  # Environment variables
  template "#{deploy[:deploy_to]}/shared/config/env" do
    source "env.erb"
    mode "0660"
    owner deploy[:user]
    group deploy[:group]
    variables(env: deploy[:environment_variables])
    notifies :run, resources(execute: "restart Rails app #{application}")

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  template "/etc/environment" do
    source "environment.erb"
    mode "0644"
    owner "root"
    group "root"
    variables(env: deploy[:environment_variables])
    notifies :run, resources(execute: "restart Rails app #{application}")

    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config")
    end
  end

  execute "symlinking subdir mount if necessary" do
    command "rm -f /var/www/#{deploy[:mounted_at]}; ln -s #{deploy[:deploy_to]}/current/public /var/www/#{deploy[:mounted_at]}"
    action :run
    only_if do
      deploy[:mounted_at] && File.exists?("/var/www")
    end
  end

end
