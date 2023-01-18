class TrackSearch < SearchBase
  private

  def default_sort
    {id: {order: :desc}}
  end

  def search_target
    TracksIndex
  end

  def search_conditions
    {
      must: {
        free_word_query: %i[name],
        term_query: %i[realease_date seconds]
      },
      must_not: {}
    }
  end

  def source_fields
    %i[name email composer album realease_date seconds]
  end
end
