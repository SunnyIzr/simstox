class TradeValidator < ActiveModel::Validator
  def validate(trade)
    if ( trade.quantity + trade.position.quantity ) < 0
      trade.errors[:portfolio] << "does not have sufficient inventory to cover this trade"
    end 

    if ( trade.portfolio.cash_cents - (trade.quantity * trade.price_cents) ) < 0
      trade.errors[:portfolio] << "does not have sufficient funds to cover this trade"
    end
  end
end