require 'curses'
require 'io/console'
require 'logger'

require 'mee/tui'

include  MEE::TUI

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
			TUI_LOGGER.info { "Doh!" }
		end

		status.draw
		sleep 0.25
	end
ensure
	Curses.close_screen
end

