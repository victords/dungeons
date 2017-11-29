require 'minigl'

include MiniGL

class Global
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  TILE_SIZE = 32

  class << self
    attr_reader :window, :stage

    def initialize(window, stage)
      @window = window
      @stage = stage
    end
  end
end
