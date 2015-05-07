require_relative 'vector'

module GeoProjector::Math
  class Polynomial < Vector
    def normalize_term!(idx)
      raise ZeroDivisionError, 'cannot normalize by term of value 0' if fetch(idx).zero_eps?
      multiply!(1 / fetch(idx))
    end

    def multiply(multiplier)
      super(multiplier, true)
    end

    def multiply!(multiplier)
      super(multiplier, true)
    end
  end
end