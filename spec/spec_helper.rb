# 必要ファイルの読み込み
require 'rubygems'
require 'awesome_print'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'active_record'
require 'active_support/core_ext'

# DBへの接続
dbconfig = YAML::load(File.open('database.yml'))
ActiveRecord::Base.establish_connection(dbconfig['development'])

# ajaxの通信などで待ちが発生する場合の最大待ち時間
Capybara.default_wait_time = 30

# seleniumを使う
Capybara.default_driver = :selenium

RSpec.configure do |config|
  config.include Capybara::DSL
end
