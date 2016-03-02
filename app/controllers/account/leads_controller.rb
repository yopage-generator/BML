class Account::LeadsController < Landing::BaseController
  layout 'leads'

  def index
    render locals: {
      collections: current_landing.collections,
      current_collection: current_collection,
      fields: fields,
      utm_fields: utm_fields,
      leads: leads,
      filter: leads_filter
    }
  end

  private

  def fields
    current_collection.fields.ordered
  end

  def utm_fields
    Lead.utm_fields
  end

  def leads
    paginate LeadsQuery.new(filter: leads_filter).call
  end

  def leads_filter
    LeadsFilter.new filter_params
  end

  def filter_params
    params.merge(
      collection: current_collection,
      variant: current_variant,
    )
  end

  def current_collection
    find_collection || current_landing.default_collection
  end

  def find_collection
    return nil unless params[:collection_id]

    current_landing.collections.find params[:collection_id]
  end

  def current_variant
    find_variant || current_landing.default_variant
  end

  def find_variant
    return nil unless params[:variant_id]

    current_landing.variants.find_by id: params[:variant_id]
  end
end
