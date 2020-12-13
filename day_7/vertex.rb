class Vertex
  attr_reader :name, :edges, :parent
  attr_accessor :contains

  def initialize(name)
    @name = name
    @edges = []
    @parent = []
    @contains = []
  end

  def add_edge(vertex)
    @edges << vertex
  end

  def find_edges(name)
    @edges.select { |v| v.name == name }
  end

  def add_parent(vertex)
    @parent << vertex
  end
end
