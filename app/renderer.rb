# frozen_string_literal: true

require 'pastel'

class Renderer
  DEFAULT_WIDTH = 80
  SEPARATOR_CHAR = "\u2500" # ─

  def initialize(width: DEFAULT_WIDTH, pastel: nil)
    @width = width
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
      title_line(session.title),
      agent_model_line(session.agent, session.model),
      tokens_cost_line(session.tokens, session.cost),
      location_line(session.location)
    ].join("\n")
  end

  def separator
    @pastel.dim(SEPARATOR_CHAR * @width)
  end

  def title_line(title)
    truncated = truncate(title, @width - 4)
    "  #{@pastel.bold.cyan(truncated)}"
  end

  def agent_model_line(agent, model)
    "  Agent: #{agent}          Model: #{model}"
  end

  def tokens_cost_line(tokens, cost)
    tokens_str = comma_format(tokens)
    cost_str = format('$%.4f', cost)
    "  Tokens: #{tokens_str.ljust(11)} Cost: #{cost_str}"
  end

  def location_line(location)
    truncated = truncate(location, @width - 14)
    "  #{@pastel.dim("Location: #{truncated}")}"
  end

  def truncate(str, max_len)
    return str if str.length <= max_len

    "#{str[0, max_len - 3]}..."
  end

  def comma_format(number)
    number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end
