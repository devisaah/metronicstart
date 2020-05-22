# Metronic Rails Template

Um modelo de aplicativo rápido do Rails, o modelo em específico utiliza o template
 [metronic](https://keenthemes.com/metronic/ "metronic").


**Começando**

O metronic start é um modelo do rails, então você executa como uma opção na criação de um novo aplicativo.


    rails new dunnas -d postgresql -m https://raw.githubusercontent.com/devisaah/metronicstart/master/template.rb
    rails new dunnas -d mysql -m https://raw.githubusercontent.com/devisaah/metronicstart/master/template.rb
    
    # # # rodando na maquina local  # # #  
    rails new dunnas -d postgresql -m home/isaahmdantas/dunnas/metronicstart/template.rb
    rails new dunnas -d mysql -m home/isaahmdantas/dunnas/metronicstart/template.rb
   
**Gerando um scaffold**   


    rails g scaffold Servico nome:string descricao:text deleted_at:datetime:index ativo:boolean --no-test-framework
    
