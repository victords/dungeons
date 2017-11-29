require_relative 'global'

class Player < GameObject
  def initialize(block)
    super 0, 0, 32, 32, :face, nil, 2, 2
    @obst = [block]
  end

  def update
    forces = Vector.new(0, 0)
    update_forces(forces, Gosu::KbLeft, -3, 0, 3, 0)
    update_forces(forces, Gosu::KbRight, 3, 0, -3, 0)
    update_forces(forces, Gosu::KbUp, 0, -3, 0, 3)
    update_forces(forces, Gosu::KbDown, 0, 3, 0, -3)

    move(forces, @obst, [])
  end

  private
  def update_forces(forces, key, x_pressed, y_pressed, x_released, y_released)
    if KB.key_pressed? key
      forces.x += x_pressed
      forces.y += y_pressed
    elsif KB.key_released? key
      forces.x += x_released if @speed.x != 0
      forces.y += y_released if @speed.y != 0
    end
  end
end