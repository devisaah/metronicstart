class EmpresaPadrao < SeedMigration::Migration
  def up
    @empresa = Empresa.new 
    @empresa.razao_social = "Hospital Maternidade Almeida Castro"
    @empresa.nome_fantasia = "Hospital Maternidade Almeida Castro"
    @empresa.cnpj = "99.999.999/9999-99"
    @empresa.site = "maternidadealmeidacastro.com.br"
    @empresa.logo = File.new("#{Rails.root}/app/assets/images/logo.png")
    @empresa.favicon = File.new("#{Rails.root}/app/assets/images/favicon.ico")

    cont2 = Contato.new(tipo: :email, valor: 'contato@maternidadealmeidacastro.com.br')
    cont3 = Contato.new(tipo: :telefone, valor: '(84) 3315-1030')

    @empresa.contatos << cont2
    @empresa.contatos << cont3

    rs2 = RedeSocial.new(tipo: :facebook, url: 'https://www.facebook.com/maternidadealmeidacastro?_rdc=1&_rdr', ativo: true)
    rs3 = RedeSocial.new(tipo: :instagram, url: 'https://www.instagram.com/maternidadealmeidacastro_/', ativo: true)
    rs1 = RedeSocial.new(tipo: :whatsapp, url: 'https://api.whatsapp.com/send?phone=558433151030', ativo: true)

    @empresa.redes_sociais << rs1
    @empresa.redes_sociais << rs2
    @empresa.redes_sociais << rs3

    endereco = Endereco.new 
    endereco.cep = "59611040"
    endereco.logradouro = "R. Juvenal Lamartine"
    endereco.numero = "334"
    endereco.bairro = "Centro"
    endereco.lat = "-5.1865665"
    endereco.lng = "-37.3435805"
    endereco.cidade = Cidade.where(nome: 'Mossoró').first_or_create
    endereco.estado = Estado.where(sigla: 'RN').first_or_create

    @empresa.endereco = endereco

    @empresa.save(validate: false)
  end

  def down
    Empresa.destroy_all
  end
end