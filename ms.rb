require 'yaml'
require 'colorize'

def save_game(curr_game)
    File.open('Minesweeper.yml',"w") { |file| file.write(curr_game.to_yaml)}
end

class Minesweeper
    def initialize
        @grid = Array.new(9) {Array.new(9,0)}
        @game_over = true
        @flag_pair = []
        @known_empty = []
        plant_bombs
        display_nums   
    end

    #Counts the total bombs present on the map.
    def num_bombs
        count = 0
        (0...9).each do |ro|
            (0...9).each do |co|
                if @grid[ro][co] == :B
                    count += 1 
                end
            end
        end
        count
    end

    # Randomly plants bombs around the map. Since there are 81 spots
    # I felt 15 bombs was a good amount.
    def plant_bombs
        while num_bombs < 15
            rand_col = rand(@grid.length)
            rand_row = rand(@grid.length)
            @grid[rand_col][rand_row] = :B
        end
    end

    #This finds every coordinate that is a bomb. Then uses helper
    #Function "surround_nums" to mark areas around the bomb with +1
    def display_nums
        (0...9).each do |ro|
            (0...9).each do |co|
                if @grid[ro][co] == :B
                    surround_nums(ro,co)
                end
            end
        end
    end

    # After planting the bombs, a number border is generated around it. Adding a 1 to every tile 
    # that touches the bomb.
    def surround_nums(row, col)
        # North
        @grid[row-1][col] += 1 if ((row - 1) > -1) && @grid[row-1][col] != :B        
        # NE
        @grid[row - 1][col + 1] += 1 if ((row - 1) > -1) && ((col+1) < 9) && @grid[row - 1][col + 1] != :B        
        # East
        @grid[row][col+1] += 1 if ((col+1) < 9) && @grid[row][col+1] != :B        
        # SE
        @grid[row+1][col+1] += 1 if ((row + 1) < 9) && ((col+1) < 9) && @grid[row+1][col+1] != :B         
        # South
        @grid[row + 1][col] += 1 if ((row + 1) < 9) && @grid[row + 1][col] != :B         
        # SW
        @grid[row + 1][col - 1] += 1 if ((row + 1) < 9) && ((col-1) > -1) && @grid[row + 1][col - 1] != :B        
        # West
        @grid[row][col - 1] += 1  if ((col - 1) > -1) && @grid[row][col - 1] != :B   
        # NW
        @grid[row - 1][col - 1] += 1  if ((row - 1) > -1) && ((col - 1 ) > -1) && @grid[row - 1][col - 1] != :B
    end

    # Checks to see there is no flag at a position. If there isn't 
    # it places one.
    def flag_map(row,col)
        row = row.to_i
        col = col.to_i
        row -= 1
        col -= 1
        if @known_empty.include? (row.to_s + col.to_s)
            puts 'You can not put a flag in an empty spot.'
        elsif @flag_pair.include? (row.to_s + col.to_s) 
            puts 'You can not put a flag there.'
        else
            @flag_pair << (row.to_s + col.to_s)
        end
    end

    # Checks to see if a flag is at a position. If there is
    # the flag is removed.
    def unflag_map(row,col)
        row = row.to_i
        col = col.to_i
        row -= 1
        col -= 1
        if @flag_pair.include? (row.to_s + col.to_s)
            @flag_pair.delete((row.to_s + col.to_s))
        else
            puts 'There is no flag there!'
        end
    end
        
    #The board the player sees after every move. Hides bombs. 
    def display_board
        row_idx = -1
        numera = [1,2,3,4,5,6,7,8,9]
        @display = @grid.map do |row|
            
            col_idx = -1
            row_idx += 1 
            row.map do |col|            
                col_idx += 1            
                if @flag_pair.include? ((row_idx.to_s) + (col_idx.to_s))
                    col = 'F'.orange
                elsif col == :B
                    col = 'H'.green
                elsif (@known_empty.include? ((row_idx.to_s) + (col_idx.to_s))) && (numera.include? col)
                    col = col.to_s.red
                elsif @known_empty.include? ((row_idx.to_s) + (col_idx.to_s))
                    col = 'O'.blue
                else
                    col = 'H'.green
                end        
            end        
        end
    end

    #Once a player makes a valid move. This spreads the map so that 
    #you get an open area with a border of numbers. Works Recursively.
    def open_up(row,col)
        return if @grid[row][col] == nil
        return if @known_empty.include? (row.to_s + col.to_s)
        numera = [1,2,3,4,5,6,7,8,9]
        if numera.include? @grid[row][col]
            @known_empty << (row.to_s + col.to_s)
            return    
        end
        
        @known_empty << (row.to_s + col.to_s)
        # North
        open_up(row-1,col) if row-1 > -1
        # NE
        open_up(row - 1,col + 1) if (row > -1) && (col + 1 < 9)    
        # East
        open_up(row,col+1) if (col+1 < 9)
        # SE
        open_up(row+1,col+1) if (row+1 < 9) && (col + 1 < 9)       
        # South
        open_up(row + 1,col) if row + 1 < 9  
        # SW
        open_up(row + 1,col - 1) if (row + 1 < 9) && (col - 1  > -1)
        # West
        open_up(row,col - 1) if col - 1 > -1  
        # NW
        open_up(row - 1,col - 1) if (row -1 > -1) && (col - 1 > -1) 

        return

    end

    #Decides if the player's move is valid.
    #You can't try and reveal a spot already known.
    #You can't reveal a spot that has a flag on it.
    def player_choice(row,col)
        row = row.to_i
        col = col.to_i
        row = row - 1 
        col = col - 1
        if @known_empty.include? ((row.to_s)+(col.to_s))
            puts 'That spot is already known.'
        elsif @flag_pair.include? ((row.to_s)+(col.to_s))
            puts "You can't guess where you have a flag."
            
        elsif @grid[row][col] == 0
            open_up(row,col)
        elsif @grid[row][col] == :B
            puts 'YOU LOSE, SORRY'
            @game_over = false
        else
            @known_empty << (row.to_s + col.to_s)
        end
    end

    #A Getter for the game_over variable.
    def game_over
        @game_over
    end

    #Shows the display board. Player can not see bombs. 
    def show_board
        @display.each do |row|
            puts row.join(' ')
        end
    end

    #Displays the entire board, showing all the bomb placements.
    def loser_board
        @grid.each do |row|
            puts row.join(' ')
        end
    end

    #Player decides if they want to flag, unflag, or make a move.
    def player_move
        player_position = gets.chomp
        player_position = player_position.split(' ')
        if player_position[0] == 'flag'
            flag_map(player_position[1], player_position[2])
        elsif player_position[0] == 'unflag'
            unflag_map(player_position[1], player_position[2])
        else
            player_choice(player_position[0], player_position[1])
        end
        display_board
        
        show_board if game_over == true 

    end


end

puts 'Welcome to Minesweeper!'
puts 'Would you like to start from your last game? (Y / N)'
open_game = gets.chomp
if open_game.downcase == 'y'
    game = YAML.load(File.read('Minesweeper.yml'))
else
    game = Minesweeper.new
end

puts ' '
puts 'To pick a coordinate, enter it as such: "3 4"'
puts 'To flag a coordinate, enter it as such: "flag 3 4"'
puts 'To unflag a coordinate, enter it as such: "unflag 3 4"'
puts ' ' 

while game.game_over
    puts 'Choose a coordinate!'
    game.player_move
    save_game(game)
end

game.loser_board



