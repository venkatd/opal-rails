require 'spec_helper'

describe Opal::SourceMap do
  let(:maps_dir)    { File.expand_path('../../tmp/__source_maps__', __FILE__) }
  let(:source_path) { File.join maps_dir, 'example_class.js.rb' }
  let(:parsed_path) { source_path.gsub(/\.rb$/,'') }
  let(:map_path)    { source_path + '.map' }
  let(:map_url)     { "file://#{map_path}" }
  let(:source_url)  { "file://#{source_path}" }
  let(:parsed)      { Opal.parse source, source_path }
  let(:source) do 
    <<-RUBY
    class ExampleClass
      def say_hi!
        # We throw from js it's tracked back 
        # to this method instead of the corelib
        `throw('asdf')`
        puts 'hi there!'
      end
    end
    ExampleClass.new.say_hi!
    RUBY
  end
  
  before do
    FileUtils.rm_rf maps_dir 
    Opal::SourceMap.maps_dir = maps_dir
  end
  
  it 'sets cross paths in map and compiled files' do
    parsed.should respond_to(:source_map)
    Dir[maps_dir+'/*'].should     include(map_path)
    parsed.lines.to_a.last.should include(map_url)
    File.read(map_path).should    include(source_url)
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
