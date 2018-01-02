require_relative 'global'

class Key < GameObject
  attr_reader :dead

  def initialize(x, y)
    super(x + 8, y + 8, Global::T_S - 16, Global::T_S - 16, :key, Vec.new(0, -2))
  end

  def update
    if Global.player.bounds.intersect?(bounds)
      Global.player.key_count += 1
      @dead = true
    end
  end
end