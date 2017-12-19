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
  end

  def reset
    @state = :normal
  end

  def update
    @buttons.each(&:update)
    @state
  end

  def draw
    @buttons.each(&:draw)
  end
end
