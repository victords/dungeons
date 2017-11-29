require_relative 'global'

class Stage
  attr_reader :width, :height, :obstacles

  def initialize(number)
    File.open("#{Res.prefix}/stage/#{number}") do |file|
      lines = file.readlines.map { |line| line.strip }

      @width = lines[0].length
      @height = lines.length
      @tiles = Array.new(@width) { Array.new(@height) }
      @obstacles = []

      lines.each_with_index do |line, y|
        (0...line.length).each do |x|
          if line[x] == '#'
            @tiles[x][y] = GameObject.new(x * Global::TILE_SIZE,
                                          y * Global::TILE_SIZE,
                                          Global::TILE_SIZE,
                                          Global::TILE_SIZE,
                                          :wall)
            @obstacles << @tiles[x][y]
          end
        end
      end

      @map = Map.new(Global::TILE_SIZE, Global::TILE_SIZE, @width, @height)
    end
  end

  def draw
    @map.foreach do |i, j, x, y|
      if @tiles[i][j]
        @tiles[i][j].draw
      else
        Global.window.draw_quad x, y, 0xffabcdef,
                                x + Global::TILE_SIZE, y, 0xffabcdef,
                                x, y + Global::TILE_SIZE, 0xffabcdef,
                                x + Global::TILE_SIZE, y + Global::TILE_SIZE, 0xffabcdef, 0
      end
    end
  end
end