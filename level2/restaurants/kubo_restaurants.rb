# frozen_string_literal: true
#test
# Restaurant class
class Restaurant
  attr_reader :name, :items

  def initialize(name)
    @name = name
    @items = []
  end

  def add_items(*items)
    @items += items
  end

  def remove_item(item_name)
    @items.reject! { |item| item.name == item_name }
  end

  def place_order(order_items, discount: 0)
    order_price = 0
    checked_items = []
    order_items.each do |order_item|
      return DOUBLE_DISCOUNT_ERROR if order_item[:discount] && discount.positive?

      checked_item = @items.find { |i| i.name == order_item[:name] }
      return UNAVAILABLE_ITEM_ERROR unless checked_item&.in_stock?(order_item[:count])

      checked_items << checked_item
      order_price += checked_item.price * order_item[:count] * (1 - order_item[:discount].to_f)
    end
    checked_items.each { |item| item.remove_from_stock(order_items) }
    order_price * (1 - discount.to_f)
  end
end

# Item class
class Item
  attr_reader :name, :price
  attr_accessor :stock

  def initialize(name, price, stock)
    @name = name
    @price = price
    @stock = stock
  end

  def remove_from_stock(order_items)
    @stock -= order_items.find { |i| i[:name] = @name }[:count]
  end

  def in_stock?(count)
    count <= @stock
  end
end
