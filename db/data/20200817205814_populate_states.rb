class PopulateStates < SeedMigration::Migration
  require 'net/http'
  require 'net/https' # for ruby 1.8.7
  require 'json'

  def up
    # pegando a lista de estados
    def self.states
      http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
      JSON.parse http.get('/celsodantas/br_populate/master/states.json').body
    end

    # populando estados e cidades
    states.each do |state|
      state_obj = Estado.new(:sigla => state["acronym"], :nome => state["name"])
      state_obj.save
      state["cities"].each do |city|
        c = Cidade.new
        c.nome = city["name"]
        c.estado = state_obj
        c.save
      end
    end
  end

  def down
    Cidade.destroy_all
    Estado.destroy_all
  end
end
