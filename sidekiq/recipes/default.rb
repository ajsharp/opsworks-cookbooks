#
# Cookbook Name:: sidekiq
# Recipe:: default
#

node[:deploy].each do |application, deploy|
  template "#{node[:monit][:conf_dir]}/sidekiq_#{application}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "monitrc.conf.erb"
    variables({
      :app_name => application,
      :deploy   => deploy,
      :sidekiq  => deploy[:sidekiq]
    })
  end

  execute "ensure-sidekiq-is-setup-with-monit" do
    command "monit reload"
  end

  execute "restart-sidekiq" do
    command %(echo "sleep 20 && monit -g sidekiq_#{application} restart all")
  end
end
