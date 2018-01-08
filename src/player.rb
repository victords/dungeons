require_relative 'global'

# Represents the player
class Player < GameObject
  SPEED = 3
  D_SPEED = SPEED * 2**0.5 * 0.5
  POWER_UP_MULT = 1.618
  MAX_HEALTH = 4

  attr_reader :dead, :extra_speed
  attr_accessor :key_count

  def initialize
    super 0, 0, 32, 32, :face, nil, 3, 2
    @health = 3
    @invulnerable = 0
    @powered = 0
    @key_count = 0
    @extra_speed = Vec.new(0, 0)
    @text_helper = TextHelper.new(Global.font)
    @heart_icon = Res.imgs(:heart, 2, 2)[0]
    @key_icon = Res.img(:key)
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
    speed *= POWER_UP_MULT if @powered > 0
    speed += @extra_speed
    @extra_speed.x = @extra_speed.y = 0
    move(speed, Global.stage.obstacles, [], true)

    @invulnerable -= 1 if @invulnerable > 0
    @powered -= 1 if @powered > 0
    @img_index = @powered > 0 ? 5 : 4 - @health

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

  def add_health(amount = 1)
    @health += amount
    @health = MAX_HEALTH if @health > MAX_HEALTH
  end

  def power_up
    @powered = 600 # 600 frames = 10 seconds
  end

  def start
    @x = @y = @invulnerable = @powered = @key_count = 0
    @health = 3
    @extra_speed = Vec.new(0, 0)
    @dead = false
  end

  def draw
    super Global.stage.map

    if @dead
      # dead message
      G.window.draw_quad(0, 0, 0x80000000,
                         Global::SCREEN_WIDTH, 0, 0x80000000,
                         0, Global::SCREEN_HEIGHT, 0x80000000,
                         Global::SCREEN_WIDTH, Global::SCREEN_HEIGHT, 0x80000000, 1)
      @text_helper.write_line(text: 'You are dead', x: Global::SCREEN_WIDTH / 2, y: Global::SCREEN_HEIGHT / 2 - 12, mode: :center)
    else
      # panel
      G.window.draw_quad(Global::SCREEN_WIDTH - 70, 10, 0x80ffffff,
                         Global::SCREEN_WIDTH - 10, 10, 0x80ffffff,
                         Global::SCREEN_WIDTH - 70, 60, 0x80ffffff,
                         Global::SCREEN_WIDTH - 10, 60, 0x80ffffff, 1)
      @heart_icon.draw(Global::SCREEN_WIDTH - 65, 14, 1)
      @text_helper.write_line(text: @health.to_s, x: Global::SCREEN_WIDTH - 15, y: 10, mode: :right, color: 0xffffff, effect: :border, z_index: 1)
      @key_icon.draw(Global::SCREEN_WIDTH - 63, 36, 1)
      @text_helper.write_line(text: @key_count.to_s, x: Global::SCREEN_WIDTH - 15, y: 35, mode: :right, color: 0xffffff, effect: :border, z_index: 1)
    end
  end
end
