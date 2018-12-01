#!/usr/bin/env ruby

require 'json'
require 'active_support'
require 'active_support/hash_with_indifferent_access'

require 'hashie'

class Hash
  include Hashie::Extensions::MethodAccess
end

tile_config = JSON.load(File.read(ARGV[0]))
tiles = tile_config["tiles-new"][0].tiles
tiles.each do | tile |
  if tile.respond_to?(:fg)
    if tile.fg.is_a?(Integer)
      tile.fg = [tile.fg]
    end
  end
  # if tile["bg"]
  #   puts 'bg resp'
  #   if tile["bg"].is_a?(Integer)
  #     tile["bg"] = [tile["bg"]]
  #     pp tile["bg"]
  #   end
  # end
end

tile_config["tiles-new"][0]["tiles"] = tiles
puts tile_config.to_json