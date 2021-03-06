require 'rubygems'
require 'sinatra/base'
require 'json'
require 'yaml'

module ChefCommand
  extend self

  def chef_classroom
    "cd /root/chef_classroom"
  end

  def chef_client
    "#{chef_classroom} && chef-client -z --logfile chef-client.log -r"
  end

  def deploy_workstations
    "#{chef_client} 'role[class],recipe[chef_classroom::deploy_workstations]'"
  end

  def deploy_chef_server
    "#{chef_client} 'role[class],recipe[chef_classroom::deploy_chef_server]'"
  end

  def deploy_first_nodes
    "#{chef_client} 'role[class],recipe[chef_classroom::deploy_first_nodes]'"
  end

  def deploy_multi_nodes
    "#{chef_client} 'role[class],recipe[chef_classroom::deploy_multi_nodes]'"
  end

  def refresh_portal
    "#{chef_client} 'role[class],recipe[chef_classroom::_refresh_portal]'"
  end

  def destroy_workstations
    "#{chef_client} 'role[class],recipe[chef_classroom::destroy_workstations]'"
  end

  def destroy_lab
    "#{chef_client} 'role[class],recipe[chef_classroom::destroy_lab]'"
  end

end

class Portal < Sinatra::Base

  def data_file
    # Lets talk a little about why I am hard-coding this value. Currently in
    # the cookbook that I am working I am attempting to run this project with
    # rackup. Well it turns out that the current working directory is not
    # right so instead of doing the right thing right now I'm going to hard-code
    # that value within the server.
    '/root/portal_site/nodes.yml'
  end

  def data
    YAML.load(File.read(data_file))
  end

  def class_name
    data[:class_name]
  end

  def console_address
    data[:console_address]
  end

  def students
    data[:students]
  end

  def chef_servers
    data[:chefserver]
  end

  def key
    File.read(data[:key]) rescue "NO KEY FOUND"
  end

  get '/' do
    erb :index, :locals => { :class_name => class_name,
      :console_address => console_address,
      :students => students,
      :chef_servers => chef_servers,
      :key => key }
  end

  get '/deploy_workstations' do
    logger.info "Deploying Workstations: #{ChefCommand.deploy_workstations}"
    Process.spawn(ChefCommand.deploy_workstations)
    { success: true }.to_json
  end

  get '/deploy_chef_server' do
    logger.info "Deploying Workstations: #{ChefCommand.deploy_chef_server}"
    Process.spawn(ChefCommand.deploy_chef_server)
    { success: true }.to_json
  end

  get '/deploy_first_nodes' do
    logger.info "Deploying Workstations: #{ChefCommand.deploy_first_nodes}"
    Process.spawn(ChefCommand.deploy_first_nodes)
    { success: true }.to_json
  end

  get '/deploy_multi_nodes' do
    logger.info "Deploying Workstations: #{ChefCommand.deploy_multi_nodes}"
    Process.spawn(ChefCommand.deploy_multi_nodes)
    { success: true }.to_json
  end

  get '/refresh_portal' do
    logger.info "Refreshing Portal"
    Process.spawn(ChefCommand.refresh_portal)
    { success: true }.to_json
  end

  get '/destroy_workstations' do
    logger.info "Destroying Workstations"
    Process.spawn(ChefCommand.destroy_workstations)
    { success: true }.to_json
  end

  get '/destroy_lab' do
    logger.info "Destroying Lab"
    Process.spawn(ChefCommand.destroy_lab)
    { success: true }.to_json
  end
end
