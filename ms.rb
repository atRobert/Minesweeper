class Minesweeper
    def initialize
        @grid = Array.new(9) {Array.new(9,:H)}
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

    # def [](arr)
    #     row = arr[0]
    #     col = arr[1]
    #     return @grid[row][col]
    # end

    # def []=(arr,val)
    #     row = arr[0]
    #     col = arr[1]
    #     @grid[row][col] = val
    # end

    def plant_bombs
        twenty_percent = 81*0.20
        while num_bombs < twenty_percent
            rand_col = rand(@grid.length)
            rand_row = rand(@grid.length)
            @grid[rand_col][rand_row] = :B
        end
    end


end
