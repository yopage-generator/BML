class LeadsQuery
  include Virtus.model

  attribute :filter, LeadsFilter

  def call
    s = basic_scope

    Lead.utm_fields.each do |f|
      filter_value = filter.send(f.key)
      s = s.where(f.item_key => filter_value) if filter_value.present?
    end

    s.order order
  end

  private

  def basic_scope
    filter.collection.leads
  end

  def order
    return { id: :desc } unless sort_field_present?
    { filter.sort_field => sort_order }
  end

  def sort_order
    filter.sort_order == :asc ? filter.sort_order : :desc
  end

  def sort_field_present?
    filter.sort_field.present? &&
      Lead::UTM_FIELDS.include?(filter.sort_field)
  end
end
