class Search::TrackService
  FORMAT_FIELDS = %i[seconds free_word]
  DEFAULT_SORT = [{id: {order: :desc}}]

  def initialize params
    @params = params[:search] || {}
    @search_params = {}
  end

  def perform
    format_search_params

    TrackSearch.new(search_params).filter
  end

  private

  attr_reader :params, :search_params

  def format_search_params
    # search_params[:withdrawn] = false

    FORMAT_FIELDS.each do |field|
      send "format_#{field}"
    end
  end

  def format_seconds
    return if params[:seconds].blank?

    to = params[:seconds].to_i.minutes.to_i
    search_params[:seconds] = {from: 3.minutes.to_i, to: to}
  end

  def format_pagination_and_sort
    search_params[:page] = params[:page] || 1
    search_params[:per_page] = params[:per_page] || 10
    search_params[:sort] = params[:sort] || DEFAULT_SORT
  end

  def format_free_word
    return if params[:free_word].blank?

    search_params[:free_word] = params[:free_word]
      .split(Regexp.union([",", "、"])).map(&:strip).reject(&:blank?)
  end
end
