# frozen_string_literal: true

RailsAdmin::Engine.routes.draw do
  concern :model_action do |options|
    prefix = options[:prefix]

    RailsAdmin::Config::Actions.all(:root).each do |action|
      match "/#{action.route_fragment}", action: action.action_name, as: "#{prefix}#{action.action_name}", via: action.http_methods
    end
    scope ':model_name' do
      RailsAdmin::Config::Actions.all(:collection).each do |action|
        match "/#{action.route_fragment}", action: action.action_name, as: "#{prefix}#{action.action_name}", via: action.http_methods
      end
      post '/bulk_action', action: :bulk_action, as: "#{prefix}bulk_action"
      scope ':id' do
        RailsAdmin::Config::Actions.all(:member).each do |action|
          match "/#{action.route_fragment}", action: action.action_name, as: "#{prefix}#{action.action_name}", via: action.http_methods
        end
      end
    end
  end

  controller 'main' do
    concerns :model_action
  end

  controller 'scoped' do
    scope ':owner_model_name/:owner_id' do
      concerns :model_action, prefix: :scoped
    end
  end
end
