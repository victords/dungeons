require_relative 'global'

# Represents the player
class Player < GameObject
  SPEED = 3
  D_SPEED = SPEED * 2**0.5 * 0.5

  def initialize(block)
    super 0, 0, 32, 32, :face, nil, 2, 2
    @obst = [block]
  end

  def update
    speed = Vector.new(0, 0)
    if KB.key_down? Gosu::KbUp
      if KB.key_down? Gosu::KbLeft
        speed.x -= D_SPEED
        speed.y -= D_SPEED
      elsif KB.key_down? Gosu::KbRight
        speed.x += D_SPEED
        speed.y -= D_SPEED
      else
        speed.y -= SPEED
      end
    elsif KB.key_down? Gosu::KbDown
      if KB.key_down? Gosu::KbLeft
        speed.x -= D_SPEED
        speed.y += D_SPEED
      elsif KB.key_down? Gosu::KbRight
        speed.x += D_SPEED
        speed.y += D_SPEED
      else
        speed.y += SPEED
      end
    elsif KB.key_down? Gosu::KbLeft
      speed.x -= SPEED
    elsif KB.key_down? Gosu::KbRight
      speed.x += SPEED
    end

    move(speed, @obst, [], true)
  end
end
