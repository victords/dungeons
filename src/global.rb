require 'minigl'

include MiniGL

Vec = MiniGL::Vector
Btn = MiniGL::Button

# Stores global constants and references
class Global
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  T_S = 32

  class << self
    attr_reader :font
    attr_accessor :stage, :player, :cur_level

    def initialize
      @font = Res.font :dejavu, 16

      save_dir = "#{File.expand_path('~')}/.dungeons"
      Dir.mkdir(save_dir) unless File.exist?(save_dir)
      @save_file = "#{save_dir}/save"
      File.open(@save_file, 'a+') do |file|
        content = file.read
        if content.empty?
          @cur_level = 1
          file.write(@cur_level.to_s)
        else
          @cur_level = content.to_i
        end
      end
    end

    def save_progress
      File.open(@save_file, 'w') do |file|
        file.write(@cur_level.to_s)
      end
    end
  end
end
