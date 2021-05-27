# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
ActiveSupport::Inflector.inflections do |inflect|
    # Classes (Models)
    inflect.irregular 'usuario', 'usuarios' 
    inflect.irregular 'permissao', 'permissoes' 
    inflect.irregular 'permissao_item', 'permissao_itens'
    inflect.irregular 'estado', 'estados'
    inflect.irregular 'cidade', 'cidades'
    inflect.irregular 'endereco', 'enderecos'
    inflect.irregular 'contato', 'contatos'
    inflect.irregular 'rede_social', 'redes_sociais'
    inflect.irregular 'empresa', 'empresas'
    inflect.irregular 'configuracao', 'configuracoes' 
    inflect.irregular 'mensagem', 'mensagens'
    inflect.irregular 'noticia', 'noticias'
end