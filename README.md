# MEE::TUI

Provides a simple graph for rendering text based componets.  Right now it only offers a progress bar and a text display, in addition to some basic layout functionality.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mee-tui'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mee-tui

## Usage

Most basic usage:

```ruby
require 'mee/tui'

include MEE::TUI

class TestScreen < Screen
  def on_init
    attach( TextDisplay.new( "Test" ) ) 
    attach( TextDisplay.new( "Test" ) ) 
  end 

  def layout_manager
    VerticalLayoutManager.new
  end 
end

begin
  example = TestScreen.new
  example.setup
	example.draw
ensure
  Curses.close_screen
end
```

It's fairly borning example.  Something like this is slightly more interesting:

```ruby
require 'mee/tui'

include MEE::TUI

class Readout < Screen
  attr_accessor :discovery, :download, :entries, :categorized

  def initialize
    super()

    @discovery = LabledProgressDisplay.new( "Discovery", 30 )
    @download = LabledProgressDisplay.new( "S3 Downlaod", 30 )
    @entries = LabledProgressDisplay.new( "Lines to entries", 30 )
    @categorized = LabledProgressDisplay.new( "Categorization", 30 )
  end 

  def on_init
    attach( @discovery )
    attach( @download )
    attach( @entries )
    attach( @categorized )
  end 

  def layout_manager
    VerticalLayoutManager.new
  end 
end

begin
  status = Readout.new
  status.setup

  ( 0..100 ).each do
    case Random.new.rand( 4 ) 
    when 0
      status.discovery.increment 1 
    when 1
      status.download.increment 2
    when 2
      status.entries.increment 3 
    when 3
      status.categorized.increment 4 
    else
			raise "Doh!"
    end 

    status.draw
    sleep 0.25
  end 
ensure
  Curses.close_screen
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meschbach/ruby-mee-tui.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
