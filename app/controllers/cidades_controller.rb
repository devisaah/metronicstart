class CidadesController < ApplicationController
  def search
    @cidades = Cidade.search(params[:search])
    render :json => @cidades
  end
end
  