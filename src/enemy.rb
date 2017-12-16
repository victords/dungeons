require_relative 'global'

# Represents the enemies
class Enemy < GameObject
  SPEED = 3

  def initialize(number, x, y)
    super x, y, Global::T_S, Global::T_S, "enemy#{number}", Vector.new(0, 0)
    points = route(number).map do |a|
      Vector.new(x + a[0] * Global::T_S, y + a[1] * Global::T_S)
    end
    @points = [Vector.new(x, y)].concat(points)
  end

  def update
    cycle(@points, SPEED)
    Global.player.dead = true if Global.player.bounds.intersect?(bounds)
  end

  def route(number)
    case number
    when 1 then [[1, 0], [1, 1], [0, 1]]
    when 2 then []
    end
  end
end
