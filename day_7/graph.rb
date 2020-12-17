# frozen_string_literal: true

class Graph
  attr_accessor :vertices

  def initialize
    @vertices = Set.new
  end

  def find_vertex?(name)
    @vertices.any? { |v| v.name == name }
  end

  def select_vertex(name)
    @vertices.select { |obj| obj.name == name }.first
  end

  def add_vertex(vertex)
    @vertices << vertex
  end
end
