require_relative 'enemy'

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
      @enemies = []

      lines.each_with_index do |line, j|
        (0...line.length).each do |i|
          if line[i] != '_'
            x = i * Global::TILE_SIZE
            y = j * Global::TILE_SIZE
          end
          if line[i] == '#'
            @tiles[i][j] = true
            @obstacles << Block.new(x, y, Global::TILE_SIZE, Global::TILE_SIZE, false)
          elsif line[i] == 'G'
            @goal = Sprite.new(x, y, :goal)
            @goal_rect = Rectangle.new(x + Global::TILE_SIZE / 2 - 4, y + Global::TILE_SIZE / 2 - 4, 8, 8)
          elsif line[i] == '!'
            @enemies << Enemy.new(1, x, y)
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
    @enemies.each(&:update)
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
    @enemies.each { |e| e.draw(@map) }
  end
end
