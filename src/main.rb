require_relative 'player'
require_relative 'stage'
require_relative 'menu'

# Represents the game window and controls the game state
class Game < GameWindow
  def initialize
    super Global::SCREEN_WIDTH, Global::SCREEN_HEIGHT, false

    Res.prefix = File.expand_path(__FILE__).split('/')[0..-3].join('/') + '/data'

    Global.initialize(self)

    @menu = Menu.new
    @state = :menu
  end

  def needs_cursor?
    @state == :menu
  end

  def update
    KB.update
    Mouse.update
    if @state == :menu
      if @menu.update == :play
        @state = :play
        Global.player = Player.new
        Global.stage = Stage.new(@stage_index = 1)
      end
    else
      Global.player.update
      Global.stage.update
      return unless Global.stage.completed
      @stage_index += 1
      Global.stage = Stage.new(@stage_index)
      Global.player.start
    end
  end

  def draw
    if @state == :menu
      @menu.draw
    else
      Global.stage.draw
      Global.player.draw
    end
  end
end

Game.new.show
