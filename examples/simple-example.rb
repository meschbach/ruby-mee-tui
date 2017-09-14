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

status = TestScreen.new
begin
	status.setup
	status.draw
	sleep 1
ensure
	status.done
end
