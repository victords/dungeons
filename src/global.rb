require 'minigl'

include MiniGL

# Stores global constants and referencess
class Global
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  T_S = 32

  class << self
    attr_reader :window, :font
    attr_accessor :stage, :player

    def initialize(window)
      @window = window

      @font = Res.font :dejavu, 16
    end
  end
end
