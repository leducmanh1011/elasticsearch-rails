class Search::TrackService
  FORMAT_FIELDS = %i[seconds]
  DEFAULT_SORT = [{id: {order: :desc}}]

  def initialize params
    @params = params
    @search_params = {}
  end

  def perform
    # format_search_params

    TrackSearch.new(search_params).filter
  end

  private

  attr_reader :params, :search_params

  def format_search_params
    search_params[:withdrawn] = false

    FORMAT_FIELDS.each do |field|
      send "format_#{field}"
    end
  end

  def format_seconds

  end

  def format_pagination_and_sort
    search_params[:page] = params[:page] || 1
    search_params[:per_page] = params[:per_page] || 10
    search_params[:sort] = params[:sort] || DEFAULT_SORT
  end
end
