require_relative 'global'

class Star < GameObject
  attr_reader :dead

  def initialize(x, y)
    super x + Global::T_S / 2 - 8, y + Global::T_S / 2 - 8, 16, 16, :star, Vec.new(-2, -2)
  end

  def update
    if Global.player.bounds.intersect?(bounds)
      Global.player.power_up
      @dead = true
    end
  end
end
