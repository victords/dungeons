require_relative 'player'
require_relative 'stage'
require_relative 'menu'

# Represents the game window and controls the game state
class Game < GameWindow
  def initialize
    super Global::SCREEN_WIDTH, Global::SCREEN_HEIGHT, false

    Res.prefix = File.expand_path(__FILE__).split('/')[0..-3].join('/') + '/data'

    Global.initialize

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
        Global.stage = Stage.new(Global.cur_level)
      end
    elsif KB.key_pressed?(Gosu::KbEscape)
      @menu.reset
      @state = :menu
    else
      Global.player.update
      if Global.stage.update
        Global.stage = Stage.new(Global.cur_level += 1)
        Global.player.start
      elsif Global.player.dead
        if KB.key_pressed?(Gosu::KbReturn)
          @menu.reset
          @state = :menu
        end
      end
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
Global.save_progress
