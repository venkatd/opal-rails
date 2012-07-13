require 'opal'
require 'source_map'

module Opal
  module SourceMap
    module StringWithSourceMap
      attr_accessor :source_map, :source_map_path
      def source_map_path= path
        @source_map_path = path
        self << "\n//@ sourceMappingURL=#{source_map_path}"
      end
    end
    
    def parse_with_source_map source, file='(file)'
      parse_without_source_map(source, file).tap do |parsed|
        map_source = ''
        map = ::SourceMap.new(:file => file, :generated_output => map_source)
              
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
        
        map_dir = Rails.root.join("public/__source_maps__/")
        File.mkdir map_dir
        map_path = File.join(map_dir, "#{file}.map")
        parsed.extend StringWithSourceMap
        parsed.source_map = map
        parsed.source_map_path = map_path
        
        File.open(map_path, 'w') {|f| f << map_source}
      end
    end
  end
  
  class << self
    alias parse_without_source_map parse
    include SourceMap
    alias parse parse_with_source_map
  end
end
