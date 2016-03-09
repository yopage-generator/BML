class Lead < ActiveRecord::Base
  UTM_FIELDS = [
    :utm_source,
    :utm_campaign,
    :utm_medium,
    :utm_term,
    :utm_content,
    :referer
  ]

  belongs_to :collection, counter_cache: :leads_count
  belongs_to :variant, counter_cache: :leads_count
  belongs_to :landing

  scope :ordered, -> { order 'id desc' }

  validates :collection, :variant, :data, presence: true

  before_create :generate_public_number
  before_create :set_number
  before_create :set_landing
  before_create :fill_current_utms
  after_create :create_collection_fields

  # TODO вынести в хелперы
  #
  def self.utm_fields
    UTM_FIELDS.map do |f|
      OpenStruct.new(
        key: f,
        item_key: f,
        title: I18n.t("utm_fields.#{f}")
      )
    end
  end

  def to_s
    "Заявка N#{public_number}"
  end

  private

  def fill_current_utms
    # TODO думать какие устанвить first/last
    self.utm_source = last_utm_source
    self.utm_campaign = last_utm_campaign
    self.utm_medium = last_utm_medium
    self.utm_term = last_utm_term
    self.utm_content = last_utm_content

    self.referer = last_referer.presence || first_referer
  end

  def set_landing
    self.landing_id = variant.landing_id
  end

  def generate_public_number
    self.public_number = SecureRandom.hex(4).upcase
  end

  def set_number
    self.number ||= variant.leads.count + 1
  end

  def create_collection_fields
    data.keys.reject { |k| k == 'cookie' }.each do |key|
      collection.fields.upsert key: key, title: key
    end
  end
end