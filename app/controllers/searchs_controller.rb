class SearchsController < ApplicationController
  def index
    @tracks, @total_count = Search::TrackService.new(params).perform
  end
end
 