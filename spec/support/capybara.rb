RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, options: {
      url: "http://selenium_chrome:4444/wd/hub",
    }
    Capybara.app_host = "http://rails"
    Capybara.server_host = "rails"
    Rails.application.routes.default_url_options[:host] = "rails"
  end
end
