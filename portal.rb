require 'rubygems'
require 'sinatra/base'
require 'json'

module ChefCommand
  extend self

  def deploy_workstations
    "chef-client -z -r 'recipe[chef_classroom::deploy_workstations]'"
  end

  def deploy_server
    "chef-client -z -r 'recipe[chef_classroom::deploy_server]'"
  end

  def deploy_first_nodes
    "chef-client -z -r 'recipe[chef_classroom::deploy_first_nodes]'"
  end

  def deploy_multi_nodes
    "chef-client -z -r 'recipe[chef_classroom::deploy_multi_nodes]'"
  end

  def refresh_portal
    "chef-client -z -r 'recipe[chef_classroom::_refresh_portal]'"
  end

  def destroy_workstations
    "chef-client -z -r 'recipe[chef_classroom::destroy_workstations]'"
  end

  def destroy_all
    "chef-client -z -r 'recipe[chef_classroom::destroy_all]'"
  end

end

class Portal < Sinatra::Base

  def node
    { 'chef_classroom' => { 'class_name' => 'CLASSNAME' },
      'ec2' => { 'public_ipv4' => '54.13.13.13' }
    }
  end

  def workstations
    [
      { 'ec2' => { 'public_ipv4' => '54.13.13.1' } },
      { 'ec2' => { 'public_ipv4' => '54.13.13.2' } }
    ]
  end

  def node1s
    [
      { 'ec2' => { 'public_ipv4' => '54.1.1.11' }, 'platform_family' => 'centos' },
      { 'ec2' => { 'public_ipv4' => '54.1.1.12' }, 'platform_family' => 'centos' }
    ]
  end

  def node2s
    [
      { 'ec2' => { 'public_ipv4' => '54.1.1.21' }, 'platform_family' => 'windows' },
      { 'ec2' => { 'public_ipv4' => '54.1.1.22' }, 'platform_family' => 'windows' }
    ]
  end

  def node3s
    [
      { 'ec2' => { 'public_ipv4' => '54.1.1.31' }, 'platform_family' => 'ubuntu' },
      { 'ec2' => { 'public_ipv4' => '54.1.1.32' }, 'platform_family' => 'ubuntu' }
    ]
  end

  def chef_servers
    [ { 'ec2' => { 'public_ipv4' => '99.99.99.99' } } ]
  end

  def key
    "PRIVATE KEY
    PRIVATE KEY
    PRIVATE KEY
    PRIVATE KEY
    PRIVATE KEY
    PRIVATE KEY"
  end

  get '/' do
    erb :index, :locals => { :node => node,
      :workstations => workstations,
      :node1s => node1s,
      :node2s => node2s,
      :node3s => node3s,
      :chef_servers => chef_servers,
      :key => key }
  end

  get '/deploy_workstations' do
    logger.info "Deploying Workstations: #{ChefCommand.deploy_workstations}"
    Process.spawn(ChefCommand.deploy_workstations)
    { success: true }.to_json
  end

  get '/deploy_server' do
    logger.info "Deploying Workstations: #{ChefCommand.deploy_server}"
    Process.spawn(ChefCommand.deploy_server)
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

  get '/destroy_all' do
    logger.info "Destroying All"
    Process.spawn(ChefCommand.destroy_all)
    { success: true }.to_json
  end
end


