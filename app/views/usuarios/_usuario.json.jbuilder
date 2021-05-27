json.extract! usuario, :id, :nome, :email, :username, :ativo, :permissao_id, :password, :password_confirmation, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
