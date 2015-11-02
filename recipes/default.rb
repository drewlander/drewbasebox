#
# Cookbook Name:: drewbsaebox
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  action :create
  not_if {File.exists? '/etc/yum.repos.d/epel.repo'}
end

%w{ git vim tmux fail2ban-firewalld}.each do |package|
  package package do
    action :install
  end
end

service 'fail2ban' do
  supports :restart => true, :reload => true
  action :nothing
end

cookbook_file '/etc/fail2ban/jail.local' do
  source 'jail.local'
  notifies :restart, 'service[fail2ban]'
end
