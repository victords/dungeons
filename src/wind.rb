require_relative 'global'

class Wind < GameObject
  SPEED = 1

  attr_reader :dead

  def initialize(direction, x, y)
    super(x + 2, y + 2, Global::T_S - 4, Global::T_S - 4, :wind, Vec.new(-2, -2), 2, 2)
    @direction = direction
  end

  def update
    animate([0, 1, 2, 3], 5)

    if Global.player.bounds.intersect?(bounds)
      if @direction == :up
        Global.player.extra_speed.y -= SPEED
      elsif @direction == :down
        Global.player.extra_speed.y += SPEED
      elsif @direction == :left
        Global.player.extra_speed.x -= SPEED
      else
        Global.player.extra_speed.x += SPEED
      end
    end
  end

  def draw(map)
    super(map, 1, 1, 255, 0xffffff, @direction == :up ? 180 : @direction == :down ? 0 : @direction == :left ? 90 : 270)
  end
end
