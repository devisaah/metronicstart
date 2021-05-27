class UsuarioPadrao < SeedMigration::Migration
  def up
    @user = Usuario.new 
    @user.nome = 'Administrador'
    @user.username = 'admin'
    @user.password = '12345678'
    @user.password_confirmation = '12345678'
    @user.email = "contato@maternidadealmeidacastro.com.br"
    @user.foto =  File.new("#{Rails.root}/app/assets/images/boy.svg")

    permission = Permissao.new 
    permission.descricao = "Permissão de Administrador"
    permission.permissao_itens << PermissaoItem.new({sistema: 'todos', acesso: 6})
    permission.save


    @user.permissao = permission 

    @user.save
  end

  def down
    Usuario.where(nome: 'Administrador').destroy_all
  end
end
