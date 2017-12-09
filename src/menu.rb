require_relative 'global'

# The game's start menu
class Menu
  def initialize
    @play_button = Button.new(x: 350, y: 260, img: :button, text: 'Play', font: Global.font) do
      @state = :play
    end
  end

  def update
    @play_button.update
    return @state
  end

  def draw
    @play_button.draw
  end
end
