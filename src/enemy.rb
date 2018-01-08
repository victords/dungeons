require_relative 'global'

# Represents the enemies
class Enemy < GameObject
  SPEED = 3

  attr_reader :dead

  def initialize(number, x, y)
    super x, y, Global::T_S, Global::T_S, :enemy, Vec.new(0, 0), 2, 2
    points = route(number).map do |a|
      Vec.new(x + a[0] * Global::T_S, y + a[1] * Global::T_S)
    end
    @points = [Vec.new(x, y)].concat(points)
    @img_index = number - 1
  end

  def update
    cycle(@points, SPEED)
    Global.player.hit if Global.player.bounds.intersect?(bounds)
  end

  def route(number)
    case number
    when 1 then [[1, 0], [1, 1], [0, 1]]
    when 2 then []
    when 3 then [[2, 0], [2, 2], [0, 2]]
    when 4 then [[2, 0], [3, 1], [3, 3], [2, 4], [0, 4], [-1, 3], [-1, 1]]
    else []
    end
  end
end
