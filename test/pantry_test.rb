require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class PantryTest < Minitest::Test
  def test_it_exists
    pantry = Pantry.new

    assert_instance_of Pantry, pantry
  end

  def test_stock_starts_as_empty_hash
    pantry = Pantry.new

    assert_equal ({}), pantry.stock
  end

  def test_items_stock_start_at_zero
    pantry = Pantry.new

    assert_equal 0, pantry.stock_check("Cheese")
  end

  def test_it_can_restock
    pantry = Pantry.new

    pantry.restock("Cheese", 10)
    pantry.restock("Cheese", 20)

    assert_equal 30, pantry.stock_check("Cheese")
  end

  def test_shopping_list_starts_empty
    pantry = Pantry.new

    assert_equal ({}), pantry.shopping_list
  end

  def test_it_can_add_to_the_shopping_list
    pantry = Pantry.new
    recipe_1 = Recipe.new("Cheese Pizza")
    recipe_1.add_ingredient("Cheese", 20)
    recipe_1.add_ingredient("Flour", 20)
    recipe_2 = Recipe.new("Spaghetti")
    recipe_2.add_ingredient("Spaghetti Noodles", 10)
    recipe_2.add_ingredient("Marinara Sauce", 10)
    recipe_2.add_ingredient("Cheese", 5)

    pantry.add_to_shopping_list(recipe_1)
    pantry.add_to_shopping_list(recipe_2)

    expected = {"Cheese" => 25, "Flour" => 20, "Spaghetti Noodles" => 10, "Marinara Sauce" => 10}
    assert_equal expected, pantry.shopping_list
  end

  def test_it_can_print_the_shopping_list
    pantry = Pantry.new
    recipe_1 = Recipe.new("Cheese Pizza")
    recipe_1.add_ingredient("Cheese", 20)
    recipe_1.add_ingredient("Flour", 20)
    recipe_2 = Recipe.new("Spaghetti")
    recipe_2.add_ingredient("Spaghetti Noodles", 10)
    recipe_2.add_ingredient("Marinara Sauce", 10)
    recipe_2.add_ingredient("Cheese", 5)
    pantry.add_to_shopping_list(recipe_1)
    pantry.add_to_shopping_list(recipe_2)

    expected = "* Cheese: 25\n* Flour: 20\n* Spaghetti Noodles: 10\n* Marinara Sauce: 10"
    assert_equal expected, pantry.print_shopping_list
  end

  def test_it_can_add_to_the_cookbook
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r2 = Recipe.new("Pickles")

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)

    assert_equal [r1, r2], pantry.cookbook
  end

  def test_what_can_i_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 120)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    expected = ["Pickles", "Peanuts"]
    assert_equal expected, pantry.what_can_i_make
  end

  def test_how_many_can_i_make
    pantry = Pantry.new
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    r2 = Recipe.new("Pickles")
    r2.add_ingredient("Brine", 10)
    r2.add_ingredient("Cucumbers", 30)

    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)

    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Cucumbers", 120)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    expected = {"Pickles" => 4, "Peanuts" => 2}
    assert_equal expected, pantry.how_many_can_i_make
  end
end
