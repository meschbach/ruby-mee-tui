require_relative 'layouts'

module MEE
module TUI

module Sizing
	# sizing
	def preferred_width
		preferred_size[0]
	end

	def preferred_height
		preferred_size[1]
	end
end

module GraphUtilities
	def resize_to( width, height )
		@root.resize( height, width )
	end

	# positioning
	def move_to( x, y )
		@root.move_relative( y, x )
	end

	def resize_and_move_to( x, y, width, height )
		resize_to( width, height )
		move_to( x, y)
	end
end

class Component
	include Sizing
	include GraphUtilities

	def on_attach( to )
		@root = to
	end

	# drawing
	def draw
		draw_update
	end

	def draw_update
		raise "no window attach" unless @root
		@root.setpos( 0, 0 )
		perform_update
		@root.refresh
	end

	def perform_update
	end
end

class ComponentContainer
	include Sizing
	include GraphUtilities

	def initialize()
		@components = []
		@needs_layout = true
	end

	def attach( component )
		raise "#{self} received nil component" unless component
		@components.push( component )
		component
	end

	def on_init
	end

	def on_attach( to )
		on_init

		@root = to
		@components.each do |component|
			raise "#{self} has nil component" unless component
			window = to.subwin( component.preferred_height, component.preferred_width, 5, 5)
			component.on_attach( window )
		end
		@needs_layout = true
	end

	def preferred_size
		raise "#{self}.components is nil" unless @components
		@components.reduce( [0,0] ) { |size, component|
			preferred_size = component.preferred_size
			[ size[0] + preferred_size[0], 1 ]
		}
	end

	def resize_to( width, height )
		@root.resize( height, width )
		@needs_layout = true
	end

	def draw
		if @needs_layout
			layout_manager.layout( @root, @components )
			@needs_layout = false
		end

		@root.setpos(0,0)
		@root.clear
		@components.each do |component|
			component.draw
		end
		@root.refresh
	end

	def layout_manager
		ScaledColumnLayoutManager.new
	end
end

class Screen < ComponentContainer
	def setup
		Curses.cbreak
		root = Curses.stdscr
		on_attach( root )
	end

	def layout_manager
		VerticalLayoutManager.new
	end
end

end; end

