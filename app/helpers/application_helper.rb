module ApplicationHelper

  def highlight_text record, key
    return record["_source"][key] unless record.dig("highlight", key)

    record["highlight"][key].first.html_safe
  end
end
