# frozen_string_literal: true

Session = Struct.new(:title, :location, :agent, :model, :tokens, :cost, keyword_init: true)
