# frozen_string_literal: true

require "rollout"

require_relative "provider/version"

module OpenFeature
  module Rollout
    # Provider represents the entry point for interacting with the rollout provider
    # values. The implementation follows the details specified in https://openfeature.dev/docs/specification/sections/providers
    #
    # Provider contains functionality to configure the redis connection via
    #   rollout_client = OpenFeature::Rollout::Provider.build_client
    #   rollout_client.configure do |config|
    #     config.redis = Redis.new
    #   end
    #
    # The Provider provides the following methods and attributes:
    #
    # * <tt>metadata</tt> - Returns the associated provider metadata with the name
    #
    # * <tt>resolve_boolean_value(flag_key:, default_value:, context: nil)</tt>
    #   manner; <tt>client.resolve_boolean(flag_key: 'boolean-flag', default_value: false)</tt>
    #
    # * <tt>resolve_integer_value(flag_key:, default_value:, context: nil)</tt>
    #   manner; <tt>client.resolve_integer_value(flag_key: 'integer-flag', default_value: 2)</tt>
    #
    # * <tt>resolve_float_value(flag_key:, default_value:, context: nil)</tt>
    #   manner; <tt>client.resolve_float_value(flag_key: 'float-flag', default_value: 2.0)</tt>
    #
    # * <tt>resolve_string_value(flag_key:, default_value:, context: nil)</tt>
    #   manner; <tt>client.resolve_string_value(flag_key: 'string-flag', default_value: 'some-default-value')</tt>
    #
    # * <tt>resolve_object_value(flag_key:, default_value:, context: nil)</tt>
    #   manner; <tt>client.resolve_object_value(flag_key: 'object-flag', default_value: { default_value: 'value'})</tt>
    class Provider
      def self.build_client(rollout_client = nil)
        unless rollout_client
          rollout_client = ::Rollout.new(Redis.new)
        end

        new(rollout_client: rollout_client)
      end

      PROVIDER_NAME = "rollout Provider"

      attr_reader :metadata

      def initialize(rollout_client: nil)
        @metadata = OpenFeature::SDK::Provider::ProviderMetadata.new(name: PROVIDER_NAME)
        @rollout_client = rollout_client
      end

      def fetch_boolean_value(flag_key:, default_value:, evaluation_context: nil)
        res = @rollout_client.active?(flag_key, evaluation_context&.targeting_key)

        OpenFeature::SDK::Provider::ResolutionDetails.new(
          value: res,
          reason: "UNKNOWN", # "STATIC", "DEFAULT", "TARGETING_MATCH", "SPLIT", "CACHED", "DISABLED", "UNKNOWN", "STALE", "ERROR"
          variant: nil,
          error_code: nil,
          error_message: nil,
          flag_metadata: nil
        )
      end

      def fetch_number_value(flag_key:, default_value:, evaluation_context: nil)
        error_response(default_value, "TYPE_MISMATCH", "Rollout does not support numeric flag values")
      end

      def fetch_integer_value(flag_key:, default_value:, evaluation_context: nil)
        error_response(default_value, "TYPE_MISMATCH", "Rollout does not support numeric flag values")
      end

      def fetch_float_value(flag_key:, default_value:, evaluation_context: nil)
        error_response(default_value, "TYPE_MISMATCH", "Rollout does not support numeric flag values")
      end

      def fetch_string_value(flag_key:, default_value:, evaluation_context: nil)
        error_response(default_value, "TYPE_MISMATCH", "Rollout does not support string flag values")
      end

      def fetch_object_value(flag_key:, default_value:, evaluation_context: nil)
        error_response(default_value, "TYPE_MISMATCH", "Rollout does not support object flag values")
      end

      def error_response(default_value, error_code, error_message)
        OpenFeature::SDK::Provider::ResolutionDetails.new(
          value: default_value,
          reason: "ERROR",
          variant: nil,
          error_code: error_code,
          error_message: error_message,
          flag_metadata: nil
        )
      end
    end
  end
end
