# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
# require "minitest/example"
# require "byebug"
#
# require "minitest/autorun"
require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'

require 'redis'

require "open_feature/sdk"
require "openfeature/rollout/provider"
