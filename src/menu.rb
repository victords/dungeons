require_relative 'global'

# The game's start menu
class Menu
  def initialize
    @buttons = [
      Btn.new(x: 350, y: 260, img: :button, text: 'Play', font: Global.font) do
        @state = :play
      end,
      Btn.new(x: 350, y: 310, img: :button, text: 'Quit', font: Global.font) do
        exit
      end
    ]

    @focused = 0
  end

  def reset
    @state = :normal
  end

  def update
    if KB.key_pressed?(Gosu::KbDown) || KB.key_held?(Gosu::KbDown)
      @focused += 1
      @focused = 0 if @focused == @buttons.length
    elsif KB.key_pressed?(Gosu::KbUp) || KB.key_held?(Gosu::KbUp)
      @focused -= 1
      @focused = @buttons.length - 1 if @focused < 0
    elsif KB.key_pressed?(Gosu::KbReturn)
      @buttons[@focused].click
    end

    @buttons.each(&:update)
    @state
  end

  def draw
    @buttons.each(&:draw)
    x = @buttons[@focused].x
    y = @buttons[@focused].y
    G.window.draw_quad(x, y, 0x330000ff,
                       x + Global::BTN_W, y, 0x330000ff,
                       x, y + Global::BTN_H, 0x330000ff,
                       x + Global::BTN_W, y + Global::BTN_H, 0x330000ff, 1)
  end
end
