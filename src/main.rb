require_relative 'player'
require_relative 'stage'

class Game < GameWindow
  def initialize
    super Global::SCREEN_WIDTH, Global::SCREEN_HEIGHT, false

    Res.prefix = File.expand_path(__FILE__).split('/')[0..-3].join('/') + '/data'
    @player = Player.new
    @stage = Stage.new(1)

    Global.initialize(self, @stage)
  end

  def update
    KB.update
    @player.update
  end

  def draw
    @stage.draw
    @player.draw
  end
end

Game.new.show
