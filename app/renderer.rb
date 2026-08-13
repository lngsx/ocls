# frozen_string_literal: true

require 'pastel'

class Renderer
  DEFAULT_WIDTH = 80
  SEPARATOR_CHAR = "\u2500" # ─
  MODEL_COST_DIVIDER = "\u254D" # ╍

  def initialize(pastel: nil)
    @pastel = pastel || Pastel.new
  end

  def render(sessions)
    return '' if sessions.empty?

    "#{sessions.map { |session| card_for(session) }.join("\n")}\n"
  end

  private

  def card_for(session)
    [
      separator,
      title_line(session.title, session.agent),
      location_line(session.location),
      model_cost_line(session.model, session.tokens, session.cost)
    ].join("\n")
  end

  def separator
    @pastel.dim(SEPARATOR_CHAR * DEFAULT_WIDTH)
  end

  def title_line(title, agent)
    clean_title = title.sub(/\s*\([^)]*subagent[^)]*\)\s*$/, '')
    suffix = agent.include?('/') ? ' (subagent)' : ''
    "  #{@pastel.bold.cyan("#{clean_title}#{suffix}")}"
  end

  def model_cost_line(model, tokens, cost)
    cost_str = format('$%.4f', cost)
    tokens_str = comma_format(tokens)
    "  #{model} #{MODEL_COST_DIVIDER} #{cost_str} (#{tokens_str})"
  end

  def location_line(location)
    "  #{@pastel.dim(location)}"
  end

  def truncate(str, max_len)
    return str if str.length <= max_len

    "#{str[0, max_len - 3]}..."
  end

  def comma_format(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end
