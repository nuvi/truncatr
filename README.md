# Truncatr

This gem parses text, extracts the URLs and returns a truncated message while
maintaining the full URLs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'truncatr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install truncatr

## Usage

    Truncatr::Client.truncate("Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ipsa ratione consequuntur ducimus, tempore id blanditiis.", 50)
    # => "Lorem ipsum dolor sit amet, consectetur adipisi..."

    Truncatr::Client.truncate("Over this weekend, I spent a few hours using http://c9.io and am very pleased. Rails development on windows became possible, simple, and enjoyable!", 140)
    # => "Over this weekend, I spent a few hours using http://c9.io and am very pleased. Rails development on windows became possible, simple, and ..."

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nuvi/truncatr.

