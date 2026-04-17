class TaxonsController < ApplicationController
  def index
    @taxons = Taxon.order(:id)
  end
end
