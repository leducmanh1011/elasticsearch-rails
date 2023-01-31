class SearchsController < ApplicationController
  def index
    @tracks, @total_count = Search::TrackService.new(search_params).perform
  end

  private

  def search_params
    params.require(:search)
  end
end
 