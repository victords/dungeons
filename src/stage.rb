require_relative 'enemy'
require_relative 'door'
require_relative 'key'
require_relative 'heart'
require_relative 'star'
require_relative 'wind'
require_relative 'fan'

# Represents a stage section
class Section
  attr_reader :width, :height, :obstacles, :map, :doors

  def initialize(content)
    lines = content.split("\n")
    scenery_type = lines[0].to_i
    @floor = Res.img "floor#{scenery_type}"
    @wall = Res.img "wall#{scenery_type}"
    lines = lines[1..-1]

    @width = lines[0].length
    @height = lines.length
    @tiles = Array.new(@width) { Array.new(@height) }
    @obstacles = [
      Block.new(0, -1, @width * Global::T_S, 1, false),
      Block.new(0, @height * Global::T_S, @width * Global::T_S, 1, false),
      Block.new(-1, 0, 1, @height * Global::T_S, false),
      Block.new(@width * Global::T_S, 0, 1, @height * Global::T_S, false)
    ]
    @objects = []
    @doors = {}

    lines.each_with_index do |line, j|
      (0...line.length).each do |i|
        next if line[i] == '_'
        cell = line[i]
        x = i * Global::T_S
        y = j * Global::T_S
        if cell == '#' # wall
          @tiles[i][j] = true
          @obstacles << Block.new(x, y, Global::T_S, Global::T_S, false)
        elsif cell == '!' # goal
          @goal = Sprite.new(x, y, :goal)
          @goal_rect = Rectangle.new(x + Global::T_S / 2 - 4, y + Global::T_S / 2 - 4, 8, 8)
        elsif cell == '@' # heart
          @objects << Heart.new(x, y)
        elsif cell == '*' # star
          @objects << Star.new(x, y)
        elsif cell == '$' # key
          @objects << Key.new(x, y)
        elsif /[A-Za-z]/ =~ cell # door
          @objects << Door.new(cell.downcase, cell < 'a', x, y)
          @doors[cell.downcase] = [x, y + Global::T_S]
        elsif /[\/\\<>]/ =~ cell # wind
          @objects << Wind.new(cell == '/' ? :up : cell == '\\' ? :down : cell == '<' ? :left : :right, x, y)
        elsif /[´`()]/ =~ cell
          @objects << Fan.new(cell == '´' ? :up : cell == '`' ? :down : cell == '(' ? :left : :right, x, y)
        elsif cell.to_i > 0 # enemy
          @objects << Enemy.new(cell.to_i, x, y)
        end
      end
    end

    @map = Map.new(Global::T_S, Global::T_S, @width, @height)
  end

  def update
    Wind.affecting_player = false
    @objects.each do |o|
      o.update
      @objects.delete o if o.dead
    end
    @goal && Global.player.bounds.intersect?(@goal_rect)
  end

  def draw
    @map.foreach do |i, j, x, y|
      (@tiles[i][j] ? @wall : @floor).draw x, y, 0
    end
    @goal.draw(@map) if @goal
    @objects.each { |o| o.draw(@map) }
  end
end

# Controls the sections of a stage
class Stage
  def initialize(number)
    File.open("#{Res.prefix}/stage/#{number}") do |file|
      @sections = []
      contents = file.read.split("\n===\n")
      contents.each do |content|
        @sections << Section.new(content)
      end
      @current_section = @sections[0]
    end
  end

  def transport(door_id)
    @sections.each do |section|
      next if section == @current_section
      door = section.doors[door_id]
      if door
        @current_section = section
        Global.player.x = door[0]
        Global.player.y = door[1]
        break
      end
    end
  end

  def method_missing(name)
    if @current_section.respond_to?(name)
      @current_section.send(name)
    else
      super
    end
  end

  def respond_to_missing?(method_name, _ = false)
    %w(width height obstacles map).include? method_name
  end
end
