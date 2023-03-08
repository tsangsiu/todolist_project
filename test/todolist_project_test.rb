require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative '../lib/todolist_project'

class TodoListTest < MiniTest::Test
  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done_question
    assert_equal(false, @list.done?)
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list << 1 }
    assert_raises(TypeError) { @list << 'hi' }
    assert_raises(TypeError) { @list << [] }
  end

  def test_shovel
    new_todo = @list << @todo1
    assert_equal([@todo1, @todo2, @todo3, @todo1], new_todo.to_a)
  end

  def test_add_alias
    @todos << @todo1
    @list.add(@todo1)
    assert_equal(@todos, @list.to_a)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(3) }
    assert_equal(@todo3, @list.item_at(2))
    assert_equal(@todo2, @list.item_at(1))
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(3) }
    @list.mark_done_at(2)
    assert_equal(true, @list.item_at(2).done?)
    assert_equal(false, @list.item_at(1).done?)
    assert_equal(false, @list.item_at(0).done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(3) }
    @list.done!
    @list.mark_undone_at(2)
    assert_equal(false, @list.item_at(2).done?)
    assert_equal(true, @list.item_at(1).done?)
    assert_equal(true, @list.item_at(0).done?)
  end

  def test_done_bang
    @list.done!
    assert_equal(true, @list.item_at(2).done?)
    assert_equal(true, @list.item_at(1).done?)
    assert_equal(true, @list.item_at(0).done?)
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(3) }
    assert_equal(@todo3, @list.remove_at(2))
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_one_done
    @list.mark_done_at(2)
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    @list.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal(@todos, result)
  end

  def test_each_return
    assert_equal(@list, @list.each { |todo| })
  end

  def test_select
    result = @list.select { |todo| todo.title == 'Buy milk' }
    expect = TodoList.new(@list.title)
    expect.add(@todo1)
    assert_equal(expect.title, result.title)
    assert_equal(expect.to_a, result.to_a)
    assert_equal(TodoList, result.class)
  end
end
