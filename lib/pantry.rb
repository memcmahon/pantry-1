class Pantry
  attr_reader :stock, :shopping_list, :cookbook

  def initialize
    @stock = Hash.new(0)
    @shopping_list = Hash.new(0)
    @cookbook = []
  end

  def stock_check(item)
    @stock[item]
  end

  def restock(item, quantity)
    @stock[item] += quantity
  end

  def add_to_shopping_list(recipe)
    ingredients = recipe.ingredients
    ingredients.each do |item, quantity|
      @shopping_list[item] += quantity
    end
  end

  def print_shopping_list
    @shopping_list.map do |ingredient, amount|
      "* #{ingredient}: #{amount}"
    end.join("\n")
    # shopping_list = @shopping_list.inject("") do |shopping_list, (ingredient, amount)|
    #   shopping_list += "* #{ingredient}: #{amount}\n"
    # end.chomp
  end

  def add_to_cookbook(recipe)
    @cookbook << recipe
  end

  def what_can_i_make
    recipes = recipes_i_can_make
    recipe_names(recipes)
  end

  def how_many_can_i_make
    recipes = recipes_i_can_make
    recipes.inject({}) do |quantities, recipe|
      lowest = smallest_ingredient_amount(recipe)
      quantities[recipe.name] = lowest
      quantities
    end
  end

  #Helper methods below:
  def smallest_ingredient_amount(recipe)
    recipe.ingredients.map do |item, amount|
      stock_check(item) / amount
    end.min
  end

  def recipes_i_can_make
    recipes = @cookbook.find_all do |recipe|
      ingredients_in_stock?(recipe)
    end
  end

  def ingredients_in_stock?(recipe)
    ingredients = recipe.ingredients
    ingredients.all? do |item, amount|
      stock_check(item) >= amount
    end
  end

  def recipe_names(recipes)
    recipes.map do |recipe|
      recipe.name
    end
  end
end
