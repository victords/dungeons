require_relative 'global'

class Stage
  attr_reader :width, :height, :obstacles, :map

  def initialize(number)
    @wall = Res.img :wall
    @floor = Res.img :floor

    File.open("#{Res.prefix}/stage/#{number}") do |file|
      lines = file.readlines.map { |line| line.strip }

      @width = lines[0].length
      @height = lines.length
      @tiles = Array.new(@width) { Array.new(@height) }
      @obstacles = [
        Block.new(0, -1, @width * Global::TILE_SIZE, 1, false),
        Block.new(0, @height * Global::TILE_SIZE, @width * Global::TILE_SIZE, 1, false),
        Block.new(-1, 0, 1, @height * Global::TILE_SIZE, false),
        Block.new(@width * Global::TILE_SIZE, 0, 1, @height * Global::TILE_SIZE, false)
      ]

      lines.each_with_index do |line, y|
        (0...line.length).each do |x|
          if line[x] == '#'
            @tiles[x][y] = true
            @obstacles << Block.new(x * Global::TILE_SIZE,
                                    y * Global::TILE_SIZE,
                                    Global::TILE_SIZE,
                                    Global::TILE_SIZE,
                                    false)
          end
        end
      end

      @map = Map.new(Global::TILE_SIZE, Global::TILE_SIZE, @width, @height)
    end
  end

  def draw
    @map.foreach do |i, j, x, y|
      if @tiles[i][j]
        @wall.draw x, y, 0
      else
        @floor.draw x, y, 0
      end
    end
  end
end