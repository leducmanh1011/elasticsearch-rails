class SearchBase
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10
  SEARCH_LANGUAGES = %i[en ja]
  SPACE = [I18n.t("user.space", locale: :ja), I18n.t("user.space", locale: :en)]


  def initialize options = {}
    @options = options.to_h.deep_symbolize_keys
    @page = @options[:page].to_i.positive? ? @options[:page].to_i : DEFAULT_PAGE
    @per_page = @options[:per_page].to_i.positive? ? @options[:per_page].to_i : DEFAULT_PER_PAGE
    @per_page = 0 if options[:only_count]
    @include_options = @options[:include_options] || []
    @highlight = @options[:highlight] || true
  end

  def filter
    result = search_with_normal_pagination["hits"]
    records = result["hits"]
    total_count = result["total"]["value"]
    [records, total_count]
  end

  private

  attr_reader :options, :per_page, :page, :include_options, :highlight

  def default_source_fields
    [:id, *sort_condition.keys, *source_fields]
  end

  def highlight_option
    return {} unless @highlight

    {
      pre_tags: ["<hl-tag>"],
      post_tags: ["</hl-tag>"],
      order: "score",
      number_of_fragments: "0",
      fields: {
        "*": {}
      }
    }
  end

  def sort_condition
    default_sort
  end

  def default_sort
    raise "Not implement"
  end

  def search_target
    raise "Not implement"
  end

  def search_with_normal_pagination
    from_query = {
      from: (page - 1) * per_page
    }
    query = bool_condition.present? ? body_query.merge(from_query) : body_query_search_all
    search_target.client.search body: query
  end

  def bool_condition
    return @bool_conds if @bool_conds.present?

    @bool_conds ||= {}
    must = must_conditions
    must_not = must_not_conditions
    @bool_conds[:must] = must if must
    @bool_conds[:must_not] = must_not if must_not
    @bool_conds
  end

  def body_query_search_all
    {
      query: {match_all: {}},
      sort: [
        id: {order: :desc}
      ],
      track_total_hits: true
    }
  end

  def body_query fields = []
    {
      query: {
        bool: bool_condition
      },
      sort: [
        sort_condition,
      ].flatten,
      highlight: highlight_option,
      size: per_page,
      track_total_hits: true,
      _source: {
        includes: [*default_source_fields, *fields].flatten.map(&:to_sym).uniq
      }
    }
  end

  def range_conditions field
    {}.tap do |cond|
      cond[:gte] = field[:from] if field && field[:from]
      cond[:lte] = field[:to] if field && field[:to]
    end
  end

  def range_query field, query
    {
      range: {
        field => query
      }
    }
  end

  def term_query fields
    result = fields.map do |field|
      cond = range_conditions(options[field]).presence
      next unless options[field] && cond

      range_query field, cond
    end

    result.compact
  end

  def match_query field, query, operator = nil
    if operator.present?
      {
        match: {
          field => {
            query: query,
            operator: operator
          }
        }
      }
    else
      {
        match: {
          field => query
        }
      }
    end
  end

  def free_word_query fields
    return if options[:free_word].blank?

    search_fields = []
    SEARCH_LANGUAGES.each do |lang|
      fields.each{|field| search_fields << "#{field}.#{lang}"}
    end

    result = search_fields.map do |field|
      options[:free_word].map do |item|
        match_query field, item, :and
      end
    end

    {bool: {should: result.flatten.compact}}
  end

  def must_conditions
    must = search_conditions[:must].map do |query, fields|
      send(query, fields)
    end

    must.flatten.compact
  end

  def must_not_conditions
    must_not = search_conditions[:must_not].map do |query, fields|
      send(query, fields)
    end

    must_not.flatten.compact
  end
end
