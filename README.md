# Rails 開発の始め方
Docker Compose や GitHub Actions を用いた開発環境を構築する。  
Rails / RuboCop / RSpec / MySQL / nginx

## 開発の開始
### 初回
docker-compose.yml の myapp の箇所を作成するアプリ名に変更する。  
Dockerfile も準備する。
```
docker-compose exec rails bash
  gem install rails
  rails new . -d mysql
database.yml を適切に書き換え
  host は mysql とする
  厳密な照合をする場合、 collation: utf8mb4_bin
  MySQL デフォルトは utf8mb4_general_ci
rails db:create
```

### 既存アプリケーションの開発を開始する場合
```
docker-compose exec rails bash
  bundle install
  yarn install --check-files
  rails db:create
  rails db:migrate
```

### Docker 環境において必要
```
rails s -b 0.0.0.0
development.rb
  config.web_console.permissions = '0.0.0.0/0'
```

## RuboCop, erb-lint の導入
```ruby
group :development, :test
  gem 'rubocop-airbnb', require: false
  gem 'erb_lint', require: false
```
htmlbeautifier による erb の整形をする場合  
gem install htmlbeautifier  
tasks.json (VSCode)
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "erb beautify",
      "type": "shell",
      "command": "fp=$(echo ${file}) && if [[ ${fp##*.} == erb ]]; then htmlbeautifier ${file}; erblint ${file} --autocorrect; fi",
      "presentation": {
        "echo": false,
        "reveal": "never"
      },
      "problemMatcher": []
    }
  ]
}
```

## RSpec, factory_bot の導入
```ruby
group :development, :test
  gem 'factory_bot_rails'
  gem 'rspec-rails'

group :test
  # selenium chrome の Docker イメージを使用する場合、コメントアウトする
  # gem 'webdrivers'
```
```
rails generate rspec:install
```
config/application.rb
```ruby
config.generators do |g|
  g.test_framework :rspec,
    fixtures: false,
    view_specs: false,
    controller_specs: false,
    helper_specs: false,
    routing_specs: false
end
```
.rspec
```
--format documentation
```
spec/support/capybara.rb
```ruby
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
```
https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#rspec  
に従って設定  
spec/factories/*.rb にファクトリーを作成していく

## その他便利ツール
```ruby
group :development, :test
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'pry-byebug'
```

## 外部ライブラリの導入
```
yarn add jquery bootstrap popper.js @fortawesome/fontawesome-free
```
config/webpack/environment.js に以下の設定をすることで、どこでも $ で jQuery を利用できる  
https://github.com/rails/webpacker/blob/master/docs/webpack.md#plugins
```js
const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
  })
)
```

## 編集
app/javascript/packs/application.js
```
import "bootstrap"
import "@fortawesome/fontawesome-free/js/all"
import "../../assets/stylesheets/custom"
require("packs/main")
```
app/views/layouts/application.html.erb
```
<%= stylesheet_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
以下を body 直前に持ってくる
<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
```
注：上記は webpacker を使用する場合

## Foreman の利用
```ruby
group :development, :test
  gem 'foreman'
```
Procfile  
ポートを指定しなければ 5000 が用いられる。
```
rails-server:  rails s -p 3000 -b 0.0.0.0
webpack-watch: bin/webpack --watch
```
```
foreman start
```

## アセットのプリコンパイル(production 環境向け)
```
rails assets:clobber
rails assets:precompile
rails restart
```
