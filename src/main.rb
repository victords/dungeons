require_relative 'player'

class Game < GameWindow
  def initialize
    super 800, 600, false

    Res.prefix = File.expand_path(__FILE__).split('/')[0..-3].join('/') + '/data'
    G.gravity = Vector.new(0, 0)
    @block = GameObject.new(245, 137, 32, 32, :wall)
    @player = Player.new(@block)
  end

  def update
    KB.update
    @player.update
  end

  def draw
    @player.draw
    @block.draw
  end
end

Game.new.show