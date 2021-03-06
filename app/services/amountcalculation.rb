class Amountcalculation
  attr_accessor :order

  def initialize(order)
    @order
  end

  def calculate_amount(order, user)
    amount_ceramique = 0
    total_weight = 0
    order.basketlines.each do |basketline|
      basketline.ceramique.offer ? ceramique_discount = basketline.ceramique.offer.discount : ceramique_discount = 0
      amount_ceramique += (basketline.ceramique.price * (1 - ceramique_discount)) * basketline.quantity
      total_weight += basketline.ceramique.weight * basketline.quantity
    end
    if user
      if user.country == "FR" && total_weight > 0
        shipping_cost = ShippingCategory.where(alpha2: "FR").where("weight >= ?", total_weight).min.price_cents.to_f / 100
        {total: amount_ceramique, port: shipping_cost.to_money, weight: total_weight}
      elsif total_weight > 0
        shipping_cost = ShippingCategory.where(alpha2: user.country).where("weight >= ?", total_weight).min.price_cents.to_f / 100
        {total: amount_ceramique, port: shipping_cost.to_money, weight: total_weight}
      else
        {total: 0, port: 0, weight: 0}
      end
    else
      if total_weight > 0
        shipping_cost = ShippingCategory.where(alpha2: "FR").where("weight >= ?", total_weight).min.price_cents.to_f / 100
        {total: amount_ceramique, port: shipping_cost.to_money, weight: total_weight}
      else
        {total: 0, port: 0, weight: 0}
      end
    end
  end

end
