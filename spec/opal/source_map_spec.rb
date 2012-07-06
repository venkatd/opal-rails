require 'spec_helper'

describe Opal::SourceMap do
  it 'scans comments' do
    parsed = Opal.parse <<-RUBY, __FILE__
      class SourceMapSpec
        def method_name
          puts 'hi there!'
        end
      end
    RUBY
    
    parsed.should respond_to(:source_map)
    p parsed.source_map
  end
end
