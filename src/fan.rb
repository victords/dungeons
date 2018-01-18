require_relative 'global'

class Fan < GameObject
  attr_reader :dead

  def initialize(direction, x, y)
    super x, y, Global::T_S, Global::T_S, :fan, Vec.new(0, 0), 3, 2
    @direction = direction
  end

  def update
    animate((0..5).to_a, 3)
  end

  def draw(map)
    super(map, 1, 1, 255, 0xffffff, @direction == :up ? 180 : @direction == :down ? 0 : @direction == :left ? 90 : 270)
  end
end
