# frozen_string_literal: true

require 'dry-struct'

Types = Dry.Types()

class Session < Dry::Struct
  attribute :title,    Types::String
  attribute :location, Types::String
  attribute :agent,    Types::String
  attribute :model,    Types::String
  attribute :tokens,   Types::Integer
  attribute :cost,     Types::Float
end
