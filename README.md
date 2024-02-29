# Informações Pessoais
**Nome:** Luciano Bertuol
**E-mail:** <bertuolluciano@gmail.com>

# Detalhes Projeto
**Execução:**
Na pasta deverá conter o arquivo Configuracoes.ini, onde neste contemplará as configurações da conexão com o MongoDB e o RabbitMQ, apenas configurar e rodar a aplicação.

**Funcionamento:**
Na tela principal, conterá um campo para filtro da pesquisa, botão Pesquisar e o Botão Carregar Dados.

Poderá ser filtrado pelo CEP ou endereço completo, seguindo a dica da tela informando UF, Cidade, Logradouro (separados por vírgula). Após preencher o campo filtro será possível realizar a pesquisa através do botão pesquisar. Tela ficará travada durante a pesquisa, assim que liberada será possível clicar no botão Carregar Dados trazendo então os dados já gravados no banco de dados MongoDB.

**Práticas utilizadas:**
Foi utilizado orientação por objeto, CleanCode, abstracao, polimorfismo (Pattern Strategy). Para comunicação com RabbitMQ foi utilizado a biblioteca Stomp, para comunicação com MongoDB FireDAC.

O processo principal do projeto passa pelas principais classes:
ClientRequest: Realizado a comunicação com ViaCEP.
RabbitMQ: trativas e funcionalidades do Rabbit;
DataBase: Nesta classe faz o uso do componente ComponenteMongoDB para fins de comunição com banco de dados;
ConsultaEnderecos: onde nesta orquestra as funcionalidades das classes acima, fazendo acontecer todo o funcionamento;

Na view.principal, apenas utilizada para validações de campos e chamada da classe ConsultaEnderecos.

