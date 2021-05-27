class UsuariosDatatable
  delegate :params, :h, :t, :link_to, :content_tag, :usuario_path, :edit_usuario_path, :desativar_usuario_path, :ativar_usuario_path,  to: :@view
  include EnumI18nHelper

  def initialize(view)
    @view = view
    @remote = params[:remote] == 'true'
  end

  def as_json(options = {})
    {
        draw: params[:draw].to_i,
        recordsTotal: total,
        recordsFiltered: usuarios.total_count,
        data: data
    }
  end

  private
  def data
    usuarios.each_with_index.map do |usuario, index|
      {
          "index" => (index + 1) + ((page - 1) * per_page),
          "nome" => column_nome(usuario),
          "username" => column_username(usuario),
          "email" => column_email(usuario),
          "ativo" => column_ativo(usuario),
          "opcoes" => column_opcoes(usuario)
      }
    end
  end

  def column_nome(usuario)
    html = "#{link_to usuario.try(:nome), usuario_path(usuario), :remote => @remote}"
    html.html_safe
  end

  def column_ativo(usuario)
    usuario.try(:ativo) ? 'SIM' : 'NÃO'
  end

  def column_email(usuario)
    usuario.try(:email)
  end

  def column_username(usuario)
    usuario.try(:username)
  end

  def column_opcoes(usuario)
    opcoes = "#{link_to(usuario_path(usuario), {:remote =>  @remote, :class => 'btn btn-primary btn-icon btn-sm', title: "Visualizar", data: {toggle: "tooltip", placement: "top"}}) do
      content_tag(:i, '', :class => 'la la-search')
    end}" +
        "#{link_to(edit_usuario_path(usuario), {:remote =>  @remote, :class => 'btn btn-warning btn-icon btn-sm', title: "Editar", data: {toggle: "tooltip", placement: "top"}}) do
          content_tag(:i, '', :class => 'la la-pencil-square')
        end}" +
        "#{link_to usuario_path(usuario),
                   method: :delete,
                   data: { confirm: t('helpers.links.confirm_destroy', :model => usuario.model_name.human), toggle: "tooltip", placement: "top" },
                   :remote =>  @remote,
                   class: "btn btn-danger btn-icon btn-sm", title: "Remover" do
          content_tag(:i, '', :class => 'la la-trash')
        end}"


    if usuario.ativo?
      opcoes << "#{link_to(desativar_usuario_path(usuario), {:remote =>  true, :class => 'btn btn-icon btn-sm btn-danger', title: "Desativar Usuario", data: {toggle: "tooltip", placement: "top"}}) do
        content_tag(:i, '', :class => 'la la-close')
      end}"
    else
      opcoes << "#{link_to(ativar_usuario_path(usuario), {:remote =>  true, :class => 'btn btn-icon btn-sm btn-success', title: "Ativar Usuario", data: {toggle: "tooltip", placement: "top"}}) do
        content_tag(:i, '', :class => 'la la-check')
      end}"
    end

    return opcoes.html_safe
  end

  def usuarios
    @usuarios ||= fetch
  end

  def query
    str_query = 'Usuario'
    str_query << '.where(permissao_id: params[:permissao_id])' unless params[:permissao_id].blank?
    return str_query
  end



  def fetch
    str_query = query
    params[:columns].each do |column|
      str_query << ".where(#{column[1][:data]}: '#{column[1][:search][:value]}')" if column[1][:search][:value].present?
    end
    str_query << '.search(params[:search][:value])' if params[:search][:value].present?
    str_query << '.order("#{sort_column}" => "#{sort_direction}").page(page).per(per_page)'
    eval str_query
  end

  def total
    str_query = query
    str_query << '.count'
    eval str_query
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[created_at nome username email ativo]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end

end