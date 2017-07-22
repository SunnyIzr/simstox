class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :portfolios

  def portfolios
    object.portfolios.collect{ |portfolio| {
      name: portfolio.name.titleize,
      cash: portfolio.cash,
      market_value: portfolio.market_value,
      total_value: portfolio.total_value,
      return_value: portfolio.return_value
    }}
  end
end
