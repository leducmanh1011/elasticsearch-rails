class Integer
  def to_minutes
    _hours, mins = self.divmod(3600)
    mins, secs = mins.divmod(60)

    "#{mins.two_digits}:#{secs.two_digits}"
  end

  def two_digits
    "%02d" % self
  end
end
