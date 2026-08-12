# frozen_string_literal: true

module Ocls
  Session = Struct.new(:title, :location, :agent, :model, :tokens, :cost, keyword_init: true)
end
