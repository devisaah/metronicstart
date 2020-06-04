namespace :br_populate do
  require 'net/http'
  require 'net/https' # for ruby 1.8.7
  require 'json'

  desc "Populando os estados e cidades do Brasil."

  task populate: :environment do

    # pegando a lista de estados
    def self.states
      http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
      JSON.parse http.get('/celsodantas/br_populate/master/states.json').body
    end

    # populando estados e cidades
    count = 0
    states.each do |state|
      count = count + 1
      state_obj = Estado.new(:sigla => state["acronym"], :nome => state["name"])
      state_obj.save


      state["cities"].each do |city|
        c = Cidade.new
        c.nome = city["name"]
        c.estado = state_obj
        c.save
        puts "#{count}: Adicionando a cidade #{c.nome} ao estado #{c.estado.nome}"
      end
    end


  end

  task clean: :environment do
    Cidade.destroy_all
    Estado.destroy_all
  end

end

