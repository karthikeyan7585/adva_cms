class Test::Unit::TestResult
  alias_method :tu_passed?, :passed?
  def passed?
    return tu_passed? & ::Spec.run
  end
end