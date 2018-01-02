require_relative 'global'

# Represents an object that transports the player from one section to another
class Door < GameObject
  attr_reader :dead

  def initialize(id, locked, x, y)
    super(x + 8, y + 8, Global::T_S - 16, Global::T_S - 16, :door, Vec.new(-8, -8))
    @id = id
    @locked = locked
    @lock = Sprite.new(x + 5, y + 14, :lock, 1, 1) if @locked
    @dead = false
  end

  def update
    if Global.player.bounds.intersect?(bounds)
      if @locked
        if Global.player.key_count > 0
          @locked = false
          Global.stage.transport(@id)
        end
      else
        Global.stage.transport(@id)
      end
    end
  end

  def draw(map)
    super map
    @lock.draw(map) if @locked
  end
end
