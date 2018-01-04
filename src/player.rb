require_relative 'global'

# Represents the player
class Player < GameObject
  SPEED = 3
  D_SPEED = SPEED * 2**0.5 * 0.5
  MAX_HEALTH = 4

  attr_reader :dead
  attr_accessor :key_count

  def initialize
    super 0, 0, 32, 32, :face, nil, 3, 2
    @health = 3
    @invulnerable = 0
    @key_count = 0
  end

  def update
    speed = Vec.new(0, 0)
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

    @invulnerable -= 1 if @invulnerable > 0
    @img_index = 4 - @health

    Global.stage.map.set_camera(@x - Global::SCREEN_WIDTH / 2 + @w / 2,
                                @y - Global::SCREEN_HEIGHT / 2 + @h / 2)
  end

  def hit(damage = 1)
    return if @invulnerable > 0
    @health -= damage
    @health = 0 if @health < 0
    if @health == 0
      @dead = true
    else
      @invulnerable = 60 # 60 frames = 1 second
    end
  end

  def start
    @x = @y = @invulnerable = @key_count = 0
    @health = 3
    @dead = false
  end

  def draw
    super Global.stage.map
    Global.font.draw @key_count.to_s, 780, 5, 1, 1, 1, 0xff000000
    Global.font.draw @health.to_s, 780, 35, 1, 1, 1, 0xff000000
  end
end
