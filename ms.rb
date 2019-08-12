class Minesweeper
    def initialize
        @grid = Array.new(9) {Array.new(9,0)}
        @game_over = false
        @flag_pair = []
        @known_empty = []
        plant_bombs
        display_nums   
    end

    def grid 
        @grid
    end

    
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

    def plant_bombs
        while num_bombs < 15
            rand_col = rand(@grid.length)
            rand_row = rand(@grid.length)
            @grid[rand_col][rand_row] = :B
        end
    end

    def display_nums
        (0...9).each do |ro|
            (0...9).each do |co|
                if @grid[ro][co] == :B
                    surround_nums(ro,co)
                end
            end
        end
    end

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
        

    def display_board
        row_idx = -1
        numera = [1,2,3,4,5,6,7,8,9]
        @grid.map do |row|
            
            col_idx = -1
            row_idx += 1 
            row.map do |col|            
                col_idx += 1            
                if @flag_pair.include? ((row_idx.to_s) + (col_idx.to_s))
                    col = :F
                elsif col == :B
                    col = :H
                elsif (@known_empty.include? ((row_idx.to_s) + (col_idx.to_s))) && (numera.include? col)
                    col = col
                elsif @known_empty.include? ((row_idx.to_s) + (col_idx.to_s))
                    col = 'O'
                else
                    col = :H
                end
                
            end
            
        end
    end

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
            @game_over = false
        else
            @known_empty << (row.to_s + col.to_s)
        end
    end

    def game_over
        @game_over = true 
    end

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
    end


end

game = Minesweeper.new
while game.game_over
    game.player_move
