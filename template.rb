require "fileutils"
require "shellwords"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("metronicstart-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/devisaah/metronicstart.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{metronicstart/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails::VERSION::STRING)
end

def rails_5?
  Gem::Requirement.new(">= 5.2.0", "< 6.0.0.beta1").satisfied_by? rails_version
end

def rails_6?
  Gem::Requirement.new(">= 6.0.0.beta1", "< 7").satisfied_by? rails_version
end

def add_gems
  gem 'devise'
  gem 'cancancan'
  gem 'carrierwave'
  gem "mini_magick"
  gem 'kaminari'
  gem 'aws-sdk', '~> 3'
  gem 'fog-aws'
  gem 'asset_sync'
  gem 'exception_notification'
  gem "audited", "~> 4.9"
  gem "cocoon"
  gem 'ckeditor'
  gem 'acts_as_paranoid'
  gem 'whenever', require: false
  gem 'social-share-button',  :git => 'https://github.com/isaahmdantas/social-share-button.git'
  gem 'friendly_id', '~> 5.2.4'
  gem 'meta-tags'
  gem 'sitemap_generator'
  gem "recaptcha"
  gem 'rubyzip'
  gem 'caxlsx'
  gem 'caxlsx_rails'
  gem 'thinreports-rails'
  gem 'wicked_pdf'
  gem 'wkhtmltopdf-binary', '~> 0.12.4'
  gem 'money-rails', '~>1.12'
  gem 'protokoll',  :git => 'https://github.com/claudiotrindade/protokoll.git'
  gem "figaro"
  gem 'rack-cors', :require => 'rack/cors'
  #gem 'sidekiq', '~> 6.0', '>= 6.0.3'
  gem 'serviceworker-rails'
  gem 'seed_migration'
  gem 'validates_cpf_cnpj'
  gem 'fullcalendar-rails'
  gem 'momentjs-rails'
  gem 'therubyracer'
  gem 'br_boleto', git: 'https://github.com/devisaah/br_boleto.git'
  gem 'barby'
  gem 'chunky_png'
  gem 'rghost'
  gem 'rghost_barcode'
  gem 'activerecord-import'
  gem 'pgreset'
  gem 'brazilian-rails'
  gem 'smarter_csv'
  gem 'auto_increment'
  gem 'rails_email_checker'
end

def set_application_name
  # Add Application Name to Config
  if rails_5?
    environment "config.application_name = Rails.application.class.parent_name"
  else
    environment "config.application_name = Rails.application.class.module_parent_name"
  end

  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

def add_permissoes 
  generate "model", "Permissao",
    "descricao",
    "deleted_at:datetime:index"

  generate "model", "PermissaoItem",
    "permissao:references",
    "sistema:integer",
    "acesso:integer"
end

def add_users
  # Install Devise
  generate "devise:install"

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "Usuario",
    "nome",
    "foto",
    "username",
    "ativo:boolean",
    "deleted_at:datetime:index",
    "permissao:references"

  # Set ativo default to true
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:ativo/, ":ativo, default: true"
  end

  gsub_file "config/initializers/devise.rb",
              /  # config.authentication_keys = .+/,
              "    config.authentication_keys = [:login]"

  gsub_file "config/initializers/devise.rb",
            /  # config.secret_key = .+/,
            "  config.secret_key = Rails.application.credentials.secret_key_base"

  gsub_file "config/environments/production.rb",
    /  config.assets.js_compressor = .+/,
    "  config.assets.js_compressor = Uglifier.new(harmony: true)"

  template = """
    devise :database_authenticatable, :authentication_keys => [:login]
    attr_accessor :login
    def self.find_for_database_authentication warden_conditions
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      where(conditions).where(['lower(username) = :value OR lower(email) = :value OR lower(nome) = :value', {value: login.strip.downcase}]).first
    end
    def devise_mailer
      DeviseMailer
    end
    def active_for_authentication?
      super and self.ativo?
    end
    private
      def self.current=(usuario)
        Thread.current[:current_usuario] = usuario
      end
      def self.current
        Thread.current[:current_usuario]
      end
    """.strip

  inject_into_file("app/models/usuario.rb", "  " + template + "\n\n\n" , after: "class Usuario < ApplicationRecord\n")
end

def add_contatos 
  generate "model",  "Contato",
    "tipo:integer",
    "valor:string",
    "descricao:string",
    "contato_de:references{polymorphic}",
    "deleted_at:datetime:index"
end

def add_estados 
  generate "model",  "Estado",
    "nome:string",
    "sigla:string",
    "deleted_at:datetime:index"
end

def add_cidades 
  generate "model",  "Cidade",
    "nome:string",
    "estado:references",
    "deleted_at:datetime:index"
end

def add_enderecos 
  generate "model",  "Endereco",
    "cep",
    "logradouro",
    "numero",
    "bairro",
    "complemento",
    "lat",
    "lng",
    "estado:references",
    "cidade:references",
    "endereco_de:references{polymorphic}",
    "deleted_at:datetime:index"
end

def add_redes_sociais 
  generate "model",  "RedeSocial",
    "tipo:integer",
    "url:string",
    "ativo:boolean",
    "rs_de:references{polymorphic}",
    "deleted_at:datetime:index"
end

def add_empresa 
  generate "model",  "Empresa",
    "razao_social",
    "nome_fantasia",
    "cnpj",
    "inscricao_estadual",
    "inscricao_municipal",
    "site",
    "logo",
    "loading",
    "favicon",
    "deleted_at:datetime:index"
end

def add_mensagem 
  generate "model", "Mensagem",
    "nome",
    "email",
    "telefone",
    "assunto",
    "texto:text",
    "respondido:boolean",
    "resposta:text"
end

def add_noticia 
  generate "model",  "Noticia",
    "titulo",
    "titulobreve",
    "descricaobreve",
    "descricao:text",
    "imagem",
    "usuario:references",
    "slug:string:index"
end

def add_configuracao 
  generate "model", "Configuracao",
  "metatag_title",
  "metatag_description",
  "metatag_language",
  "metatag_keywords:text",
  "metatag_author",
  "metatag_robots",
  "metatag_revisitafter",
  "metatag_charset",
  "metatag_ogimage",
  "metatag_ogurl",
  "metatag_ogtype",
  "metatag_googleboot",
  "metatag_tcard",
  "metatag_tsite",
  "metatag_tcreator",
  "google_anlytics:text",
  "adsence_client:text",
  "google_search_console:text",
  "adsense_google_responsive:text",
  "facebook_pixel:text",
  "termo_de_uso:text",
  "politica_privacidade:text",
  "one_signal:text",
  "onesignal_appid",
  "onesignal_restapi:text",
  "jivochat:text",
  "sobre:text",
  "missao:text",
  "visao:text", 
  "valores:text",
  "whatsapp_phone",
  "whatsapp_text",
  "wc_whatsapp_primary",
  "wc_whatsapp_secondary",
  "empresa:references",
  "deleted_at:datetime:index",
  "logo_rodape"
end


def copy_templates
  remove_file "app/assets/stylesheets/application.css"

  copy_file "Procfile"
  copy_file "Procfile.dev"

  directory "app", force: true
  directory "config", force: true
  directory "lib", force: true
end

def add_whenever
  run "wheneverize ."
end

def add_friendly_id
  generate "friendly_id"

  insert_into_file(
    Dir["db/migrate/**/*friendly_id_slugs.rb"].first,
    "[5.2]",
    after: "ActiveRecord::Migration"
  )
end

def stop_spring
  run "spring stop"
end

# Configuração do seed migrate
def add_seed_migration
  rails_command "seed_migration:install:migrations"
end

# Configuração do sitemap
def add_sitemap
  rails_command "sitemap:install"
end

# Configuração do cancancan
def add_cancancan
  generate "cancan:ability"
end

# Configuração das exceções
def add_exception_notification
  template = """
    config.middleware.use ExceptionNotification::Rack,
    :email => {
        :email_prefix => '[DUNNAS TEMPLATE - Exceptions] ',
        :sender_address => %{'DUNNAS TEMPLATE' <contato@dunnassoft.com.br>},
        :exception_recipients => %w{Exceptions@dunnassoft.com.br}
    }
  """.strip

  inject_into_file("config/environments/production.rb", "  " + template + "\n\n" , before: "config.active_record.dump_schema_after_migration = false\n")
end

# Configuração da auditoria
def add_audited
  generate "audited:install"
end

# Configuração do cocoon
def add_cocoon
  inject_into_file("app/assets/javascripts/application.js", "//= require cocoon\n" , after: "//= require custom\n")
end

# Configuração do ckeditor
def add_ckeditor
  generate "ckeditor:install --orm=active_record --backend=carrierwave"

  route "mount Ckeditor::Engine => '/ckeditor'"

  insert_into_file "config/initializers/assets.rb", "\nRails.application.config.assets.precompile += %w[ckeditor/config.js]\n\n\n\n", after: "# Rails.application.config.assets.precompile += %w( admin.js admin.css )\n"
end

# Configuração do social share button
def add_social_button
  generate "social_share_button:install"
end

# Configuração do figaro
def add_figaro
  run "bundle exec figaro install"
end

# Configuração do cors
def add_cors
  template = """
      config.middleware.insert_before 0, Rack::Cors do
          allow do
              origins '*'
              resource '*', headers: :any, methods: [:get, :post, :options]
          end
      end
  """.strip

  insert_into_file "config/application.rb", "  " + template + "\n\n", after: "class Application < Rails::Application\n"
end

# configuração de fonts
def add_fonts
  inject_into_file("config/initializers/assets.rb", "Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/\n" , after: "# Rails.application.config.assets.precompile += %w( admin.js admin.css )\n")
end

# configuração da linguagem do app
def add_language
  template = """
      config.time_zone = ActiveSupport::TimeZone.new('America/Recife')
      config.i18n.default_locale = :'pt-BR'

      # paginas de erros
      config.exceptions_app = self.routes
  """.strip

  insert_into_file "config/application.rb", "  " + template + "\n\n", after: "class Application < Rails::Application\n"
end


# configuração das rotas de erro
def add_route_erros
  route "get 'wp-login.php', to: redirect('/404')"
  route "match '404', :to => 'errors#not_found', :via => :all"
  route "match '422', :to => 'errors#unacceptable', :via => :all"
  route "match '500', :to => 'errors#internal_server_error', :via => :all"

  route "get 'cidades/search', controller: 'cidades', action: :search" 
  route "get 'cidades/get_by_estado', controller: 'cidades', action: :get_by_estado" 
  route "get 'cidades/get_cidade_id', controller: 'cidades', action: :get_cidade_id" 
  route "get 'cidades/get_estado_id', controller: 'cidades', action: :get_estado_id" 
  route "get 'enderecos/get_by_endereco', controller: 'enderecos', action: :get_by_endereco"
  
  route "match '/admin/audits/show', controller: 'admin/audits', action: 'show', via: [:get]"

  route "resources :usuarios"
  route "resources :permissoes"
  route "resources :noticias"
  route "resources :configuracoes"
  route "resources :mensagens"

end

def add_serviceworker
  generate "serviceworker:install"
  generate "protokoll:migration"
  generate "seed_migration:install:migrations"
end

# Main setup
add_template_repository_to_source_path

add_gems

after_bundle do
  copy_templates

  add_audited
  add_seed_migration
  set_application_name
  stop_spring
  add_permissoes
  add_users

  add_contatos
  add_estados 
  add_cidades 
  add_enderecos 
  add_redes_sociais 
  add_empresa
  add_mensagem
  add_noticia
  add_configuracao

  add_friendly_id

  add_whenever
  add_sitemap

  add_cancancan
  add_exception_notification
  add_cocoon
  add_ckeditor
  add_social_button
  add_figaro
  add_cors

  add_fonts
  add_language
  add_route_erros
  add_serviceworker

  # Commit everything to git
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }

  say
  say "Metronicstart app successfully created!", :blue
  say
  say "To get started with your new app:", :green
  say "cd #{app_name} - Switch to your new app's directory."
end
