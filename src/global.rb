require 'minigl'

include MiniGL

# Stores global constants and referencess
class Global
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  T_S = 32

  class << self
    attr_reader :window, :player
    attr_accessor :stage

    def initialize(window, stage, player)
      @window = window
      @stage = stage
      @player = player
    end
  end
end
