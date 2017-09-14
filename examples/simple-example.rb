require 'mee/tui'
require 'curses'

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
	status = TestScreen.new
	status.setup
	status.draw
	sleep 1
ensure
	Curses.close_screen
end
