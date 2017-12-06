require_relative 'global'

class Enemy < GameObject
  def initialize(number, x, y)
    super x, y, Global::TILE_SIZE, Global::TILE_SIZE, "enemy#{number}", Vector.new(0, 0)
  end

  def update
    if Global.player.bounds.intersect?(bounds)
      puts 'morreu'
    end
  end
end