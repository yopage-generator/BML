module CurrentVariant
  NoCurrentVariant = Class.new StandardError

  def current_variant
    raise NoCurrentVariant unless Thread.current[:variant].present?

    Thread.current[:variant]
  end

  def current_variant=(variant)
    Thread.current[:variant] = variant
  end

  def safe_current_variant
    current_variant
  rescue NoCurrentVariant
    nil
  end
end
