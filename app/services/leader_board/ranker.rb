# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Style/ConditionalAssignment
module LeaderBoard
  # Пробегается по всем результатам и расставляет места согласно score
  #
  # Принимает данные в виде
  # [
  #   {
  #     records: [
  #       score: '123', # значение результата
  #       ...
  #     ]
  #   },
  # ]
  #
  # Отдает в виде
  # [
  #   {
  #     records: [
  #       rank: 1, # Место в рейтинге
  #       score: '123', # значение результата
  #       ...
  #     ]
  #   },
  # ]
  #
  class Ranker
    RANK_WITHOUT_SCORE = 0

    include Virtus.model
    attribute :records, Array[Record]

    def rank
      rank = 0
      prev_record = nil

      comparator = proc do |x, y|
        if x[:score].present? && y[:score].present?
          y[:score].to_f <=> x[:score].to_f
        elsif x[:score].nil?
          y[:score].nil? ? 0 : 1
        else
          x[:score].nil? ? 0 : -1
        end
      end

      ranker = proc do |record|
        if record[:score].present?
          record[:rank] = prev_record.present? && prev_record[:score] == record[:score] ? prev_record[:rank] : rank += 1
        else
          record[:rank] = RANK_WITHOUT_SCORE
        end
        prev_record = record
      end

      records
        .sort(&comparator)
        .each(&ranker)
    end
  end
end
