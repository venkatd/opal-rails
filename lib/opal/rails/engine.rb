require 'rails'

module Opal
  module Rails
    class Engine < ::Rails::Engine
      config.app_generators.javascript_engine :opal
      
      # Cache eager_load_paths now, otherwise the assets dir is added
      # and its .rb files are eagerly loaded.
      config.eager_load_paths
    
      initializer 'opal.source_maps' do |app|
        Opal::SourceMap.maps_dir = app.root.join('tmp/cache/source_maps')
      end
      
      initializer 'opal.assets' do |app|
        %w[opal-spec opal-dom].each do |gem_name|
          spec = Gem::Specification.find_by_name gem_name
          spec.require_paths.each do |path|
            path = File.join(spec.full_gem_path, path)
            app.config.assets.paths << path
          end
        end
      end
    end
  end
end
