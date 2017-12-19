require_relative 'enemy'
require_relative 'door'

# Represents the stage
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
        Block.new(0, -1, @width * Global::T_S, 1, false),
        Block.new(0, @height * Global::T_S, @width * Global::T_S, 1, false),
        Block.new(-1, 0, 1, @height * Global::T_S, false),
        Block.new(@width * Global::T_S, 0, 1, @height * Global::T_S, false)
      ]
      @enemies = []
      @objects = []

      lines.each_with_index do |line, j|
        (0...line.length).each do |i|
          next if line[i] == '_'
          cell = line[i]
          x = i * Global::T_S
          y = j * Global::T_S
          if cell == '#'
            @tiles[i][j] = true
            @obstacles << Block.new(x, y, Global::T_S, Global::T_S, false)
          elsif cell == 'G'
            @goal = Sprite.new(x, y, :goal)
            @goal_rect = Rectangle.new(x + Global::T_S / 2 - 4, y + Global::T_S / 2 - 4, 8, 8)
          elsif cell == 'D'
            @objects << Door.new(x, y)
          elsif cell.to_i > 0
            @enemies << Enemy.new(cell.to_i, x, y)
          end
        end
      end

      @map = Map.new(Global::T_S, Global::T_S, @width, @height)
    end
  end

  def update
    @completed = true if Global.player.bounds.intersect?(@goal_rect)
    @enemies.each(&:update)
    @objects.each(&:update)
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
    @objects.each { |o| o.draw(@map) }
  end
end
