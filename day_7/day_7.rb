# frozen_string_literal: true

require_relative 'graph'
require_relative 'vertex'
require 'set'

class BagSorter
  attr_reader :data, :graph

  def initialize(file)
    @data = File.read(file).split("\n")
    @bags = Set.new
    @graph = Graph.new
  end

  def sanitized_data
    data.map { |bags| sanitizer(bags) }
  end

  def sanitizer(str)
    arr = str.split(' contain ')
             .map do |x|
      x.gsub(/bags/, '')
       .gsub(/bag/, '')
       .tr('.', '')
    end

    contains = if arr[1] == 'no other '
                 []
               else
                 arr[1].strip.split(' , ').map do |bag|
                   new_bag = bag.split(' ')
                   { 'name' => "#{new_bag[1]} #{new_bag[2]}", 'qty' => new_bag[0].to_i }
                 end
               end
    { 'name' => arr[0].strip, 'contains' => contains }
  end

  def find_all_bags(part = :part1)
    sanitized_data.each do |bag|
      graph.vertices << Vertex.new(bag['name'])
    end

    graph.vertices.each do |v|
      contains = sanitized_data.select { |bag| bag['name'] == v.name }.first
      contains['contains'].each do |edge|
        g = graph.select_vertex(edge['name'])
        v.contains << { name: edge['name'], qty: edge['qty'] }
        v.add_edge(g)
        g.add_parent(v)
      end
    end

    case part
    when :part1
      wap = graph.vertices.select { |v| v.name == 'shiny gold' }

      parents = Set.new
      until wap.empty?
        temp = []
        wap.each do |v|
          parents << v.name
          v.parent.each { |bag| temp << bag }
        end
        wap = temp
      end

      parents.size - 1
    when :part2
      get_bag_count('shiny gold') - 1
    end
  end

  def get_bag_count(bag)
    return 1 if graph.select_vertex(bag).contains.empty?

    total = 0
    x = graph.select_vertex(bag)
    x.contains.each do |x|
      total += x[:qty] * get_bag_count(x[:name])
    end
    total + 1
  end
end
