# SAP_CAP
Creating a CAP backend


Criação de um CAP:

Utilizando do DEV SPACE de SAP Cloud Business Application.

em File escolher Open Workspace o caminho:
./home/user/projects (todos os projetos devem estar nessa pasta.) e abrir.
Digite cds e teste se o @sap/cds está instalado, caso não: comando: 
  npm install @sap/cds

Para a criação de um novo projeto:
  cds init<nome do projeto>
 
 Na pasta DB devemos criar as entidades utilizadas:
 
 Arquivo schema.cds
 
 namespace capui5;

entity Client {
    key id  :Integer;
    cpf     :String(11);
    name    :String(50);
    address :String(80);
};


Com a entidade criada, podemos criar o serviço que deixará o banco disponível.
Dessa forma:
Criei um arquivo na pasta de srv com o nome de masterdata-service.cds
Com o código:


using capui5 as capui5 from '../db/schema';

service MasterData {
    entity Client as projection on capui5.Client;    
}


E um arquivo chamado server.js com o código para habilitar o odata v2:

"use strict";

const cds = require("@sap/cds");
const proxy = require("@sap/cds-odata-v2-adapter-proxy");

cds.on("bootstrap", app => app.use(proxy()));

module.exports = cds.server;

é importante instalar a dependencia do cds-odata-v2-adapter-proxy rodando o comando: 
  npm i @sap/cds-odata-v2-adapter-proxy

como irei utilizar o Hana, é necessário fazer uma alteração nas dependencias do package.json mas antes de realizar as alterações no código digite o seguinte comando pra importar a utilização do hana:
  npm add @sap/hana-client –save
tenha Certeza de que o caminho está no seu projeto.
Agora o seguinte código deve ser copiado no package.json  
"cds": {
  "hana": {
    "syntax": "hdi"
  },
  "requires": {
    "db": {
      "kind": "hana"
    }
  }
}	

Este código se refere a utilização do hana hdi, então pode ser colocado substituindo a propriedade de dev instance sobre o sqlite3.
Após salvar é importante atualizar as dependencias do app digitando o comando:
  npm install

Para criar o banco é necessário utilizar o comando:
cds deploy --to hana <nome do banco>

Para testar se o nosso oData está funcionando você utiliza o comando: 
  cds watch

Agora pra fazer o deploy vamos utilizar os comandos:
  cds build --production
  cf push -f gen/db
  cf push -f gen/srv


pra que o link fique disponível é necessário iniciar o hana no hana cloud e iniciar as instancias no cockpit.

se esses pontos estiverem ativos, podemos acessar esse CAP pela url:
capui5posto-srv.cfapps.eu10.hana.ondemand.com



