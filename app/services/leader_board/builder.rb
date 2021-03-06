module LeaderBoard
  # Строит данные для отображения в LeaderBoard
  # на основе таблицы
  class Builder
    include Virtus.model

    # Collection не получается установить, не проходит assets:precompile
    # http://teamcity.brandymint.ru/viewLog.html?buildId=6391&buildTypeId=Bml_Master&tab=buildLog#_focus=1562
    attribute :collection # ,Collection

    def build
      @divisions = []
      @events    = []
      build_results

      Results.new(
        divisions: @divisions.uniq.sort,
        events: @events.uniq.compact.sort,
        tables: @results.values.each { |table| table.records = Ranker.new(records: table.records).rank }
      )
    end

    private

    # TODO: Перенести в свойства таблицы
    #
    EVENT_COLUMN      = :event
    SCORE_COLUMN      = :score
    DIVISION_COLUMN   = :division
    SEX_COLUMN        = :sex
    NOTE_COLUMN       = :city
    TITLE_COLUMNS     = %w(name surname firstname lastname).freeze
    UNKNOWN_TITLE     = 'Аноним'.freeze

    DEFAULT_EVENT     = 'DefaultEvent'.freeze
    DEFAULT_DIVISION  = 'DefaultDivision'.freeze

    def add_division(division)
      @divisions.push(division)
    end

    def add_event(event)
      @events.push(event)
    end

    def build_results
      @results = {}
      leads.find_each do |lead|
        division = lead.data[DIVISION_COLUMN] || DEFAULT_DIVISION
        add_division division

        event = lead.data[EVENT_COLUMN] || DEFAULT_EVENT
        add_event event

        sex = lead.data[SEX_COLUMN]
        sex = 'male' unless Column::SEX.include? sex

        note = lead.data[NOTE_COLUMN]
        title = lead.data.slice(*TITLE_COLUMNS).values.join(' ') || UNKNOWN_TITLE
        score = parse_score lead.data[SCORE_COLUMN]
        score = nil if score == 0

        ranks_table = find_ranks_table(division, event, sex)
        add_rank ranks_table[:records], title, score, note
      end
    end

    def parse_score(score)
      score = score.tr ',', '.' if score.is_a? String
      score.to_f
    end

    def result_key(*categories)
      categories.join(':')
    end

    def find_ranks_table(division, event, sex)
      get_ranks_table(division, event, sex) || create_ranks_table(division, event, sex)
    end

    def get_ranks_table(division, event, sex)
      key = result_key division, event, sex
      @results[key]
    end

    def create_ranks_table(division, event, sex)
      key = result_key division, event, sex

      ranks_table = Table.new(
        division: division,
        event: event,
        sex: sex,
        records: []
      )
      @results[key] = ranks_table
    end

    def add_rank(ranks, title, score, note)
      ranks << { title: title, note: note, score: score }
    end

    def leads
      collection.leads.accepted
    end
  end
end
