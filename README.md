# OpenFeature rollout Provider for Ruby

This is the Ruby [provider](https://openfeature.dev/docs/specification/sections/providers) implementation of rollout

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openfeature-rollout-provider'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install openfeature-rollout-provider
```

## Example

```ruby
OpenFeature::SDK.configure do |config|
  config.set_provider OpenFeature::Rollout::Provider.build_client(::Rollout.new(Redis.new))
end
```
