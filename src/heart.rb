require_relative 'global'

class Heart < GameObject
  attr_reader :dead

  def initialize(x, y)
    super x + Global::T_S / 2 - 10, y + Global::T_S / 2 - 8, 20, 16, :heart, Vec.new(0, 0), 2, 2
  end

  def update
    animate [0, 1, 2, 3], 7
    if Global.player.bounds.intersect?(bounds)
      Global.player.add_health
      @dead = true
    end
  end
end
