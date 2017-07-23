class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :update, :destroy]

  def show
    return if authenticate!(@portfolio.user)

    json_response(@portfolio)
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    return if authenticate!(@portfolio.user)

    @portfolio.save!
    json_response(@portfolio, :created)
  end

  def destroy
    return if authenticate!(@portfolio.user)

    @portfolio.destroy
    head :no_content
  end

  def update
    return if authenticate!(@portfolio.user)
    
    @portfolio.update(portfolio_params)
    json_response(@portfolio)
  end

  private

  def portfolio_params
    params.permit(:name, :cash_cents, :user_id)
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end
end
