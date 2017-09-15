require_relative 'core'

module MEE; module TUI

class ProgressBar < Component
	attr_accessor :progress

	def initialize()
		@progress = 0.0
		@limit = 100.0
	end

	def increment( amount = 1 )
		@progress = @progress + amount
	end

	def completed(); @progress; end

	def preferred_size
		[ limit, 1 ]
	end

	def limit; @limit; end
	def limit=( limit )
		limit = 1 if limit == 0
		@limit = limit
	end

	def perform_update
		cols = @root.maxx
		progress_amount = cols * ( completed / limit )
		progress_string = ( 0..progress_amount ).reduce( "" ) { | memo, i | memo + "#" }
		progress_string = progress_string[ 0..cols ]
		@root.setpos( 0, 0 )
		@root.addstr( progress_string )
	end
end

class TextDisplay < Component
	def initialize( message = "", size = nil )
		@value = message
		@size = size
	end

	def value; @value; end
	def value=( value ) ; @value = value ; end

	def preferred_size
		[ (@size || value.length), 1 ]
	end

	def perform_update
		@root.setpos( 0, 0 )
		@root.addstr( value[ 0..@root.maxx ] )
	end
end

class NumericDisplay < Component
	def initialize()
		@value = 0
	end

	def value=( value )
		@value = value
	end

	def preferred_size
		[ 7, 1 ]
	end

	def perform_update
		@root.setpos( 0, 0)
		@root.addstr( @value.to_s[ 0..@root.maxx ] )
	end
end

class ProgressDisplay < ComponentContainer
	def initialize
		super()
		@bar = ProgressBar.new
		@current = NumericDisplay.new
		@limit = NumericDisplay.new
	end

	def on_init
		super
		attach( @bar )
		attach( @current )
		attach( @limit )
	end

	def increment( amount = 1 )
		@bar.increment amount
		@current.value = @bar.completed
		@limit.value = @bar.limit
	end

	def progress=( value )
		@bar.progress = value
		@current.value = value
	end

	def limit=( value )
		@bar.limit = value
		@limit.value = value
	end
end

class LabledProgressDisplay < ProgressDisplay
	def initialize( message, size )
		super()
		@message = TextDisplay.new message, size
	end

	def on_init
		attach( @message )
		super
	end

	def label=( text )
		@message.value = text
	end
end

end; end

