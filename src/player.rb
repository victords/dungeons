require_relative 'global'

# Represents the player
class Player < GameObject
  SPEED = 3
  D_SPEED = SPEED * 2**0.5 * 0.5

  def initialize
    super 0, 0, 32, 32, :face, nil, 2, 2
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

    move(speed, Global.stage.obstacles, [], true)

    Global.stage.map.set_camera(@x - Global::SCREEN_WIDTH / 2 + @w / 2,
                                @y - Global::SCREEN_HEIGHT / 2 + @h / 2)
  end

  def draw
    super Global.stage.map
  end
end
