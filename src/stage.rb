require_relative 'global'

class Stage
  attr_reader :width, :height, :obstacles, :map, :completed

  def initialize(number)
    @wall = Res.img :wall
    @floor = Res.img :floor

    File.open("#{Res.prefix}/stage/#{number}") do |file|
      lines = file.readlines.map(&:strip)

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
          elsif line[x] == 'G'
            @goal = Sprite.new(x * Global::TILE_SIZE, y * Global::TILE_SIZE, :goal)
            @goal_rect = Rectangle.new(@goal.x + Global::TILE_SIZE / 2 - 4,
                                       @goal.y + Global::TILE_SIZE / 2 - 4,
                                       8, 8)
          end
        end
      end

      @map = Map.new(Global::TILE_SIZE, Global::TILE_SIZE, @width, @height)
    end
  end

  def update
    if Global.player.bounds.intersect?(@goal_rect)
      @completed = true
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
    @goal.draw(@map)
  end
end
