tree = %{
  key: "a",
  val: 111,
  left: %{
    key: "b",
    val: 55,
    left: %{
      key: "x",
      val: 100,
      left: %{key: "z", val: 56, left: nil, right: nil},
      right: %{key: "w", val: 23, left: nil, right: nil}
    },
    right: %{
      key: "y",
      val: 105,
      left: nil,
      right: %{key: "r", val: 77, left: nil, right: nil}
    }
  },
  right: %{
    key: "c",
    val: 123,
    left: %{
      key: "d",
      val: 119,
      left: %{key: "g", val: 44, left: nil, right: nil},
      right: %{
        key: "h",
        val: 50,
        left: %{key: "i", val: 5, left: nil, right: nil},
        right: %{key: "j", val: 6, left: nil, right: nil}
      }
    },
    right: %{key: "e", val: 133, left: nil, right: nil}
  }
}

defmodule TreeUtils do
  def add_xy(nil), do: nil

  def add_xy(tree) do
    %{
      key: tree.key,
      val: tree.val,
      left: add_xy(tree.left),
      right: add_xy(tree.right),
      x: nil,
      y: nil
    }
  end

  def depth_first(tree, level, left_limit, scale \\ 40) do
    case tree do
      %{left: nil, right: nil} ->
        x = left_limit
        y = scale * level
        {%{tree | x: x, y: y}, x, x}

      %{left: left, right: nil} ->
        {updated_left, local_root_x, local_right_limit} =
          depth_first(left, level + 1, left_limit, scale)

        x = local_root_x
        y = scale * level
        updated_tree = %{tree | x: x, y: y, left: updated_left}
        {updated_tree, x, local_right_limit}

      %{left: nil, right: right} ->
        {updated_right, local_root_x, local_right_limit} =
          depth_first(right, level + 1, left_limit, scale)

        x = local_root_x
        y = scale * level
        updated_tree = %{tree | x: x, y: y, right: updated_right}
        {updated_tree, x, local_right_limit}

      %{left: left, right: right} ->
        {updated_left, l_root_x, l_right_limit} = depth_first(left, level + 1, left_limit, scale)

        {updated_right, r_root_x, r_right_limit} =
          depth_first(right, level + 1, l_right_limit + scale, scale)

        x = div(l_root_x + r_root_x, 2)
        y = scale * level
        updated_tree = %{tree | x: x, y: y, left: updated_left, right: updated_right}
        {updated_tree, x, r_right_limit}
    end
  end
end

tree_with_xy = TreeUtils.add_xy(tree)

{final_tree, _, _} = TreeUtils.depth_first(tree_with_xy, 1, 40)

IO.inspect(final_tree)
