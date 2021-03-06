#
# Cookbook Name:: tcat
# Recipe:: default
#
# Copyright 2012,pdam
#
# Apache 2.0 license
#


include_recipe "java"
include_recipe "logrotate"

remote_file "/tmp/apache-tomcat.tar.gz" do
  source node['tomcat']['tc6_download_url']
  checksum node['tomcat']['tc6_checksum']
end

directory node['tomcat']['catalina_home']

bash "install_tomcat" do
  folder_name = node['tomcat']['tc6_download_url'].split('/')[-1].split('-bin.tar.gz')[0]
  cwd "/tmp"
  user "root"
  code <<-EOH
    tar xvzf apache-tomcat.tar.gz
    cp -r #{folder_name}/* #{node['tomcat']['catalina_home']}
    rm -rf apache-tomcat.tar.gz #{folder_name}
  EOH
end

user node['tomcat']['user']

 # if supports upstart use upstart
 if File.exists?('/sbin/initctl')
   template "/etc/init/tomcat.conf" do
     source "tomcat.conf.erb"
     mode "0755"
   end
 else
   if platform?("ubuntu", "debian")
       template "/etc/init.d/tomcat" do
         source "tomcat_debian.erb"
         mode "0755"
       end
   else
     template "/etc/init.d/tomcat" do
       source "tomcat_el.erb"
       mode "0755"
     end
   end 
 end

 if platform?("ubuntu", "debian")
   template "/etc/init.d/tomcat" do
     source "tomcat_debian.erb"
     mode "0755"
   end
 else
   template "/etc/init.d/tomcat" do
     source "tomcat_el.erb"
     mode "0755"
   end
 end

service "tomcat" do

end

# logrotate
