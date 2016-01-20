class AnalyticSource
  SOURCES = %w(yandex_direct google_adwords search social organic mails)

  include Virtus.model

  class Segment
    include Virtus.model

    attribute :title,      String
    attribute :conversion, Float
    attribute :percent,    Float
    attribute :users,      Integer
  end

  attribute :key,      String
  attribute :segments, Array[Segment]
  attribute :percent,  Float

  def self.sources
    @_sources ||= SOURCES.map { |source| new key: source }
  end

  def title
    I18n.t key, scope: [:sources]
  end
end
