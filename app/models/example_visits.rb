class ExampleVisits
  CITIES = %w(Москва Санкт-Петербурк Чебоксары Казань)

  def self.build
    new.build
  end

  def build
    time = Time.now
    20.times.map do
      AnalyticVisit.new city: random_city, sessions_count: Random.rand(10), goals_count: Random.rand(2), last_time: time -= Random.rand(500).minutes, browser: 'Safari', device: 'MacOS', source: 'Из поиска'
    end
  end

  private

  def random_city
    CITIES.sample
  end
end