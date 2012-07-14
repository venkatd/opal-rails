RSpec.configure do |config|
  config.before(:each) do
    FileUtils.rm_rf Rails.root.join('tmp/cache/*')
  end
end
