class Node
    attr_accessor :value, :left_node, :right_node

    def initialize(value, left_node = nil, right_node = nil)
      @value = value
      @left_node = left_node
      @right_node = right_node
    end
  end

  class Tree
    attr_accessor :root

    def initialize(array)
      @array = array
      @root = build_tree(@array.sort.uniq, 0, array.length - 1)
    end

    def build_tree(arr, start, finish)
      return nil if start > finish

      middle = (start + finish) / 2
      node = Node.new(arr[middle])

      node.left_node = build_tree(arr, start, middle - 1)
      node.right_node = build_tree(arr, middle + 1, finish)

      node
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
      pretty_print(node.right_node, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_node
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
      pretty_print(node.left_node, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_node
    end
  end

  # Example usage
  tree = Tree.new([3, 6, 5, 4, 2, 6, 1, 8, 9, 0, 12, 324, 12, 44, 16, 98, 76, 14, 5, 34, 98])
  tree.pretty_print
