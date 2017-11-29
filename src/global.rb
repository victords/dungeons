require 'minigl'

include MiniGL

class Global
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  TILE_SIZE = 32

  class << self
    attr_reader :window, :stage, :player

    def initialize(window, stage, player)
      @window = window
      @stage = stage
      @player = player
    end
  end
end
