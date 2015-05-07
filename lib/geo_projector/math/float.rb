class Float
  ZERO_EPSILON = 1e-32

  def zero_epsilon?
    self.abs <= ZERO_EPSILON
  end

  alias_method :zero_eps?, :zero_epsilon?
end