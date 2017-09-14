module MEE; module TUI

class ScaledColumnLayoutManager
	def layout( on, components )
		preferred_width = components.reduce( 0 ) { |memo, component|
			memo + component.preferred_size[0]
		}
		preferred_width = 1 if components.empty?

		actual_width = on.maxx
		scale = ( actual_width.to_f / preferred_width.to_f )


		x = 0
		y = 0
		components.each do |component|
			size = component.preferred_width
			scaled_width = (size * scale).floor

			component.resize_to( scaled_width, size )
			component.move_to( x, y )

			x = x + scaled_width
		end
	end
end

class VerticalLayoutManager
	def layout( on, components )
		width = on.maxx
		x = 0
		y = 0

		components.each do |component|
			height = component.preferred_height
			height = 1 if height < 1
			component.resize_and_move_to( x, y, width, height )
			y = y + height
		end
		[ width, y + 1 ]
	end
end

class AbsolutePositioningManager
	def initialize( x, y )
		super()
		@x = x
		@y = y
		@i = 0
	end

	def layout( on, components )
		components.each do |c|
			c.resize_to( 15, 15 )
			c.move_to( @x, @y + @i )
			@i = @i + 1
		end
	end
end

end; end

