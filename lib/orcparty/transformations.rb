require 'ostruct'
require 'orcparty/transformations/all'
require 'orcparty/transformations/mixin'

module Orcparty
  module Transformations
    def self.transform(ast)
      ast = All.new.transform(ast)
    end
  end
end
