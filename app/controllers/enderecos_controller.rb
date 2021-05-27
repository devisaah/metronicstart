class EnderecosController < ApplicationController

  def get_by_endereco
    url = URI.parse("https://viacep.com.br/ws/#{params[:cep].to_s}/json")
    req = Net:: HTTP::Get.new(url.to_s)
    res = Net:: HTTP.start(url.host) { | http | http.request(req) }
    formated = res.body
    endereco = JSON.parse(formated) rescue nil
    
    unless !endereco.nil? && endereco["erro"] == true
      @estado = Estado.find_by(sigla: endereco["uf"])
      c = Cidade.find_by(nome: endereco["localidade"], estado_id: @estado.try(:id))
      @cidade = !c.nil? ? Cidade.find_by(nome: endereco["localidade"], estado_id: @estado.try(:id)) : Cidade.find_by(estado_id: @estado.try(:id))

      @endereco = {
          cep: endereco["cep"],
          logradouro: endereco["logradouro"],
          complemento: endereco["complemento"],
          bairro: endereco["bairro"],
          estado: @estado,
          cidade: @cidade
      }

      render :json => @endereco
    else
      render json: { message: "CEP não encontrado! preencha os campos manualmente." }, success: false
    end
  end
  
end
