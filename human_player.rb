require_relative 'player'
require 'io/console'

class HumanPlayer < Player
	KEYBINDINGS = {
  'w' => [-1, 0], 'a' => [0, -1],
  's' => [1, 0],  'd' => [0, 1]
	}


	def initialize(color)
		super
		@selected_moves = []
	end
	
	def get_input
		@selected_moves = []
		input = nil
		until input
			input = input_from_cursor("it is #{color.to_s}'s turn")
		end
		input
	end

	def get_key
		input = $stdin.getch
		return input if ['w', 'a', 's', 'd', 'p', ' ', 'l', 'q', "\r"].include?(input)
		get_key
	end

	def input_from_cursor(message)
	    board.render
	    puts message
		input = get_key

	    case input
	    when ' '
	    	begin
	      		board.select_pos(@color, @selected_moves)
	      		return nil
	      	rescue EmptyPieceError
	      		return nil
	      	end
	    when "\r"
	      result = [board.selected_pos, board.cursor_pos]
	      return nil if result.first.nil?
	      @selected_moves << result
	      begin
		      if board.can_move_more?(@selected_moves)
		      	puts "can move more"
		      	board.select_pos(@color, @selected_moves)
		      	return nil
		      else
		      	puts "returning moves"
		      	return @selected_moves
		      end
		  rescue InvalidMoveError
		  	return nil
		  end

	  	when "p"
	  		return nil if @selected_moves == []
	  		return @selected_moves

	  	when "q"
	  		raise "quitting now"

	  	when "l"
	  		raise SaveGame

	    else
	      board.move_cursor(KEYBINDINGS[input])
	      return nil
	    end
	end    
 end