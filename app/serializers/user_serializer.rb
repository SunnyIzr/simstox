class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :portfolios

  def portfolios
    object.portfolios.collect{ |portfolio| {
      id: portfolio.id,
      name: portfolio.name.titleize,
      cash: portfolio.cash,
      market_value: portfolio.market_value,
      total_value: portfolio.total_value,
      total_pl: portfolio.total_pl,
      return_value: portfolio.return_value
    }}
  end
end
