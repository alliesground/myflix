require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Myflix
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.test_framework :rspec
      g.orm :active_record
      g.template_engine :haml
      g.helper_specs false
      g.view_specs false
      g.routing_specs false
      g.controller_specs false
      g.request_specs false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.stylesheets = false
      g.helper = false
      g.javascripts = false
    end
  end
end
