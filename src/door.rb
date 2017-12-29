require_relative 'global'

# Represents an object that transports the player from one section to another
class Door < GameObject
  def initialize(id, x, y)
    super(x + 8, y + 8, Global::T_S - 16, Global::T_S - 16, :door, Vec.new(-8, -8))
    @id = id
  end

  def update
    Global.stage.transport(@id) if Global.player.bounds.intersect?(bounds)
  end
end
