# Metronic Rails Template

O modelo gera um projeto rails no padrão de estilização do metronic e organização básica da Dunnas.

# Começando: 
`O metronicstart é um template do rails, então você executa como uma opção na criação de um novo proketo.`

```sh
$ rails new dunnas -d mysql -m https://raw.githubusercontent.com/devisaah/metronicstart/master/template.rb
```
`Ou se você realizar o clone do projeto poderá executar localmente.`

```sh
$ rails new dunnas -d mysql -m  ~/Downloads/metronicstart/template.rb
```

### Observações: 
- Utiliza o metronic v7.0.1
- Assets padrões do layout 'demo01'
- Já vem configurado autenticação básica:   
        - Model (Usuario: Nome, username, email, password)       
- Ao gerar o scaffold ele já vem com os controllers e as views no padrão que normalmente usamos na dunnas
- Ao criar o scaffold sempre colocar o atributo deleted_at:datetime:index pois já esta configurado a gem 'paranoid' (que é utilizado para ocultar o objeto ao remover sem que remova do banco)
- Os templates que a geração que o scaffold se baseia fica dentro da pasta /lib/templates ...


### Exemplo ao rodar scaffold: 
```sh
rails g scaffold Servico nome:string descricao:text deleted_at:datetime:index ativo:boolean --no-assets --no-helper --no-test-framework
```    

`*** Não vem configurado o datatable, nem os arquivos de localização e nem os inflectors.`

### Atualizações

#### 20-05-2010 
* Versão original do Metronic Start
* Versão do Metronic v7.0.1
* Layout demo01
* Versão do Rails suportadas 5.2 e 6.0
