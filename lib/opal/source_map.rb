require 'opal'
require 'source_map'

module Opal
  module SourceMap
    module StringWithSourceMap
      attr_accessor :source_map, :source_map_path
    end
    
    class << self
      attr_accessor :maps_dir
    end
    
    def parse_with_source_map source, file='(file)'
      parse_without_source_map(source, file).tap do |parsed|
        map = ::SourceMap.new(:file => file)
              
        parsed.lines.each_with_index do |line, index|
          generated_line = index+1
          next unless line =~ %r{// line (\d+), (.*), (.*)$}
          
          source_line, source_file, source_code = $1, $2, $3
          
          map.add_mapping(
            :generated_line => generated_line,
            :generated_col  => 0,
            :source_line    => source_line.to_i,
            :source_col     => 0,
            :source         => source_file
          )
        end
        
        map_dir = Opal::SourceMap.maps_dir
        FileUtils.mkdir_p map_dir
        map_path = File.join(map_dir, "#{File.basename file}.map")
        parsed.extend StringWithSourceMap
        parsed.source_map = map
        parsed.source_map_path = map_path
        parsed << "\n//@ sourceMappingURL=file://#{map_path}"
        
        File.open(map_path, 'w') {|f| f << map}
      end
    end
  end
  
  class << self
    alias parse_without_source_map parse
    include SourceMap
    alias parse parse_with_source_map
  end
end
