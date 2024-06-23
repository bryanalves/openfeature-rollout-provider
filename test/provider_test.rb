require 'test_helper'

describe 'Provider' do
  describe 'specs' do
    before do
      @rollout_stub = Minitest::Mock.new
    end

    subject { OpenFeature::Rollout::Provider.build_client(@rollout_stub) }

    it 'has metadata' do
      expect(subject).must_respond_to(:metadata)
      expect(subject.metadata).must_respond_to(:name)
      expect(subject.metadata.name).must_equal("rollout Provider")
    end

    it "has the main fetch methods" do
      assert_respond_to(subject, :fetch_boolean_value)
      assert_respond_to(subject, :fetch_integer_value)
      assert_respond_to(subject, :fetch_float_value)
      assert_respond_to(subject, :fetch_string_value)
      assert_respond_to(subject, :fetch_object_value)
    end
  end

  describe "instantiated via openfeature" do
    before do
      @rollout_stub = Minitest::Mock.new

      OpenFeature::SDK.configure do |config|
        config.set_provider(OpenFeature::Rollout::Provider.build_client(@rollout_stub))
      end
    end

    subject { OpenFeature::SDK.build_client }

    describe "fetch" do
      it 'boolean' do
        def @rollout_stub.active?(flag, user) ; false ; end
        expect(subject.fetch_boolean_value(flag_key: "boolean-flag", default_value: false)).must_equal false
      end

      it 'number (integer)' do
        expect(subject.fetch_number_value(flag_key: "integer-flag", default_value: 1)).must_equal(1)
      end

      it 'number (flaot)' do
        expect(subject.fetch_number_value(flag_key: "float-flag", default_value: 1.1)).must_equal(1.1)
      end

      it 'string' do
        expect(subject.fetch_string_value(flag_key: "string-flag", default_value: "default")).must_equal("default")
      end

      it 'object' do
        expect(subject.fetch_object_value(flag_key: "object-flag", default_value: {"a" => "b"})).must_equal({"a" => "b"})
      end
    end

    describe "get value with evaluated context" do
      it do
        def @rollout_stub.active?(flag, user) ; false ; end

        expect(
          subject.fetch_boolean_value(
            flag_key: "boolean-flag-targeting",
            default_value: false,
            evaluation_context: OpenFeature::SDK::EvaluationContext.new(context: "dummy")
          )
        ).must_equal false
      end

      it do
        def @rollout_stub.active?(flag, user) ; user == 123 ; end

        actual = subject.fetch_boolean_value(
          flag_key: "color-palette-experiment",
          default_value: false,
          evaluation_context: OpenFeature::SDK::EvaluationContext.new(targeting_key: 123)
        )

        assert_equal true, actual
      end
    end

    describe "fetch with details" do
      it 'boolean' do
        def @rollout_stub.active?(flag, user) ; false ; end

        actual = subject.fetch_boolean_details(flag_key: "boolean-flag", default_value: false).resolution_details.to_h
        assert_nil actual[:error_code]
        assert_nil actual[:error_message]
        assert_equal 'UNKNOWN', actual[:reason]
        assert_equal false, actual[:value]
        assert_nil actual[:variant]
      end

      it 'number' do
        actual = subject.fetch_number_details(flag_key: "integer-flag", default_value: 1).resolution_details.to_h
        assert_equal 'TYPE_MISMATCH', actual[:error_code]
        assert_equal  "Rollout does not support numeric flag values", actual[:error_message]
        assert_equal 'ERROR', actual[:reason]
        assert_equal 1, actual[:value]
        assert_nil actual[:variant]
      end

      it 'string' do
        actual = subject.fetch_string_details(flag_key: "string-flag", default_value: "default").resolution_details.to_h
        assert_equal 'TYPE_MISMATCH', actual[:error_code]
        assert_equal "Rollout does not support string flag values", actual[:error_message]
        assert_equal 'ERROR', actual[:reason]
        assert_equal 'default', actual[:value]
        assert_nil actual[:variant]
      end

      it 'object' do
        actual = subject.fetch_object_details(flag_key: "object-flag", default_value: {"a" => "b"}).resolution_details.to_h
        assert_equal 'TYPE_MISMATCH', actual[:error_code]
        assert_equal "Rollout does not support object flag values", actual[:error_message]
        assert_equal 'ERROR', actual[:reason]
        assert_nil actual[:variant]
      end
    end
  end
end
