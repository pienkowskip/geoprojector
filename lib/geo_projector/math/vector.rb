require_relative 'float'

module GeoProjector::Math
  class Vector < Array
    alias_method :dimensions, :size

    def subtract(other)
      dimensions_check(other)
      self.class.new(self.zip(other).map { |e1, e2| e1 - e2 })
    end

    def subtract!(other)
      dimensions_check(other)
      idx = 0
      while idx < self.size
        self[idx] -= other.fetch(idx)
        idx += 1
      end
      self
    end

    def multiply(multiplier, use_zero_epsilon = false)
      self.class.new(self.map &multiply_proc(multiplier, use_zero_epsilon))
    end

    def multiply!(multiplier, use_zero_epsilon = false)
      self.map! &multiply_proc(multiplier, use_zero_epsilon)
    end

    protected

    def dimensions_check(other)
      raise IndexError, 'vectors in different dimensional space' unless self.dimensions == other.dimensions
    end

    private

    def multiply_proc(multiplier, use_zero_eps)
      if use_zero_eps
        ->(elm) { elm.zero_eps? || multiplier.zero_eps? ? 0.0 : elm * multiplier }
      else
        ->(elm) { elm * multiplier }
      end
    end
  end
end