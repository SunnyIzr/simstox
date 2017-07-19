class PortfoliosController < ApplicationController
  before_action :set_portfolio, only: [:show, :update, :destroy]

  def show
    @portfolio = Portfolio.find(params[:id])
    json_response(@portfolio)
  end

  def create
    @portfolio = Portfolio.create!(portfolio_params)
    json_response(@portfolio, :created)
  end

  def destroy
    @portfolio.destroy
    head :no_content
  end

  def update
    @portfolio.update(portfolio_params)
    json_response(@portfolio)
  end

  private

  def portfolio_params
    params.permit(:name, :cash_cents)
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end
end
