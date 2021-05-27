json.extract! noticia, :id, :titulo, :descricao, :imagem, :autor_id, :ativo, :deleted_at, :created_at, :updated_at
json.url noticia_url(noticia, format: :json)
