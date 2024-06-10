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

  def find(num, node = @root)
    return nil if node.nil?
    puts node if node.value == num

    if num < node.value
      find(num, node.left_node)
    else
      find(num, node.right_node)
    end
  end

  def insert(num)
    current = @root

    while true
      if current.value == num
        return
      elsif current.value > num
        if current.left_node == nil
          current.left_node = Node.new(num)
          return
        end
        current = current.left_node
      else
        if current.right_node == nil
          current.right_node = Node.new(num)
          return
        end
        current = current.right_node
      end
    end

  end

  def find_near(node)
    return node if node.left_node == nil
    find_near(node.left_node)
  end

  def delete(num, node = @root, node_parent = nil)
    return nil if node == nil

    if node.value == num
      if !node.right_node && !node.left_node
        num < node_parent.value ? node_parent.left_node = nil : node_parent.right_node = nil
        return
      elsif node.left_node && !node.right_node
        num < node_parent.value ? node_parent.left_node = node.left_node : node_parent.right_node = node.left_node
        return
      elsif node.right_node && !node.left_node
        num < node_parent.value ? node_parent.left_node = node.right_node : node_parent.left_node = node.right_node
        return
      else
        near_node = find_near(node.left_node)
        delete(near_node.value)
        return node.value = near_node.value
      end
    end
    num < node.value ? delete(num, node.left_node, node) : delete(num, node.right_node, node)
  end

  def level_order
    return if @root.nil?

    queue = [@root]
    result = []

    until queue.empty?
      node = queue.shift
      if block_given?
        yield node
      else
        result << node.value if node.value != nil
      end

      queue << node.left_node if node.left_node
      queue << node.right_node if node.right_node
    end

    puts result.inspect unless block_given?
  end

  def inorder(node = @root, arr = [])
    return if node == nil

    if block_given?
      inorder(node.left_node) {|node| yield node} if node.left_node
      yield node
      inorder(node.right_node) {|node| yield node} if node.right_node
      yield node
    else
      inorder(node.left_node, arr) if node.left_node
      arr << node.value
      inorder(node.right_node, arr) if node.right_node
      arr.inspect
    end
  end

  def preorder(node = @root, arr =[])
    return if node == nil

    if block_given?
      yield node
      preorder(node.left_node, arr) {|node| yield node} if node.left_node
      preorder(node.right_node, arr) {|node| yield node} if node.right_node
    else
      arr << node.value if !arr.include?(node.value)
      preorder(node.left_node, arr) if node.left_node
      preorder(node.right_node, arr) if node.right_node
      arr.inspect
    end
  end

  def postorder(node = @root, arr = [])
    return if node.nil?

    if block_given?
      postorder(node.left_node) { |n| yield n }
      postorder(node.right_node) { |n| yield n }
      yield node
    else
      postorder(node.left_node, arr) if node.left_node
      postorder(node.right_node, arr) if node.right_node
      arr << node.value
      arr.inspect
    end
  end

  def height(node = @root, right_height = 1, left_height = 1)
    left_height += height(node.left_node) if node.left_node != nil
    right_height += height(node.right_node) if node.right_node != nil

    left_height > right_height ? left_height : right_height
  end

end

# Example usage
tree = Tree.new([3, 6, 5, 4, 2, 6, 1, 8, 9, 10, 7])
tree.pretty_print

