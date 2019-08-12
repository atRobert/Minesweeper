class Minesweeper
    def initialize
        @grid = Array.new(9) {Array.new(9,0)}
        @game_over = false
        @flag_pair = []
        @known_empty = {}
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
        twenty_percent = 81*0.05
        while num_bombs < twenty_percent
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
        if @flag_pair.include? (row.to_s + col.to_s)
            puts 'There is already a flag there!'
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
        
        @grid.map do |row|
            col_idx = -1
            row_idx += 1 
            row.map do |col|
                
                col_idx += 1
                if col == :B
                    col = :H
                elsif @flag_pair.include? ((row_idx.to_s) + (col_idx.to_s))
                    col = :F
                else
                    col = :H
                end
                
            end
            
        end
    end

    def player_choie(row,col)
        row = row.to_i
        col = col.to_s
        if @grid[row][col] == :H
            open_up(row,col)
        elsif @grid[row][col] == :E
            puts('You already know nothing is there!')
        elsif @grid[row][col] == :B
            game_over
        else
            puts('You already know how many bombs adjacent!')
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
    end


end
