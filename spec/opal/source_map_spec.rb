require 'spec_helper'

describe Opal::SourceMap do
  let(:maps_dir) { File.expand_path('../../tmp/__source_maps__', __FILE__) }
  let(:filename) { 'example_class.js.rb' }
  let(:source_path)   { File.join maps_dir, filename }
  let(:parsed_path)   { source_path.gsub(/\.rb$/,'') }
  let(:map_file_path) { source_path + '.map' }
  let(:map_url) { "file://#{map_file_path}" }
  let(:parsed) { Opal.parse source, filename }
  let(:source) { 
    <<-RUBY
    class ExampleClass
      def say_hi!
        puts 'hi there!'
        # We throw from js it's tracked back 
        # to this method instead of the corelib
        `throw('asdf')`
      end
    end
    ExampleClass.new.say_hi!
    RUBY
  }
  
  before do
    FileUtils.rm_rf maps_dir 
    Opal::SourceMap.maps_dir = maps_dir
  end
  
  it 'sets cross paths in map and compiled files' do
    parsed.should respond_to(:source_map)
    Dir[maps_dir + '/*'].should include(map_file_path)
    parsed.lines.to_a.last.should include(map_url)
    File.read(map_file_path).should include(filename)
  end
  
  after(:all) { write_files }
  
  def write_files
    File.open(parsed_path,'w') {|f| f << parsed}
    File.open(source_path,'w') {|f| f << source}
    File.open(maps_dir+'/map.html','w').puts <<-HTML
      <!DOCTYPE html>
      <hmtl>
      <head>
        <script>#{Opal.runtime}</script>
        <script src="file://#{parsed_path}"></script>
      </head>
      <body/>
      </hmtl>
    HTML
  end
end
