require_relative 'player'
require_relative 'stage'

# Represents the game window and controls the game state
class Game < GameWindow
  def initialize
    super Global::SCREEN_WIDTH, Global::SCREEN_HEIGHT, false

    Res.prefix = File.expand_path(__FILE__).split('/')[0..-3].join('/') + '/data'
    @player = Player.new
    @stage = Stage.new(@stage_index = 1)

    Global.initialize(self, @stage, @player)
  end

  def update
    KB.update
    @player.update
    @stage.update
    return unless @stage.completed
    @stage_index += 1
    Global.stage = @stage = Stage.new(@stage_index)
    @player.start
  end

  def draw
    @stage.draw
    @player.draw
  end
end

Game.new.show
