path = File.expand_path '../../', __FILE__
PATH = path
APP = "bitcoin_exchange"

require "bundler/setup"
Bundler.require :default


require "#{path}/lib/mixins/utils"
include Utils


require "#{path}/lib/monkeypatches/markedup"



def app_env
  (ENV["RACK_ENV"] && ENV["RACK_ENV"].to_sym) || :development
end

APP_ENV = app_env

class App
  def self.env
    APP_ENV
  end
end


# balance

# TODO: remember that other than wallet, even Balance (user balance, models/balance) have to be safeguarded


# wallet connections

require "#{path}/sandbox/wallet"
puts Wallet.getinfo
puts


# data store [redis]

options = {}
options[:db] = 1 if app_env == :test

R = Redis.new options

# reset
# R.keys.map{ |key| R.del key }
# R.flushdb

# data store [datamapper] mysql

test_db = "_test" if app_env == :test
DataMapper.setup :default, "mysql://localhost/bitcoin_exchange#{test_db}"


require 'bigdecimal'
require "#{path}/lib/monkeypatches/numeric"
require "#{path}/lib/monkeypatches/dates"
require "#{path}/lib/monkeypatches/hash"
require "#{path}/lib/monkeypatches/string"


# models and libs

require "#{path}/lib/ticker"
require_all "models"


DataMapper.finalize


# view code

TITLE = "BitcoinExchange"

