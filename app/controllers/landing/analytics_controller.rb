class Landing::AnalyticsController < Landing::BaseController
  include CurrentVariant

  layout 'analytics'

  def index
    render locals: { insights: ExampleInsights.build }
  end

  def sources
    render locals: { sources_data: ExampleSourcesData.build }
  end

  def funnel
  end

  def users
    render locals: { visits: ExampleVisits.build }
  end
end