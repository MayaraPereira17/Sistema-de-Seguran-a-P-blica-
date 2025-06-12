# Sistema de Segurança Pública

          


* [Python](https://spring.io/projects/spring-boot](https://www.python.org/)) - vPython 3.13 <img align="center" alt="mayara-HTML" height="30" width="40" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/python/python-original.svg" >
  

 
 
 ### Regras de negócio:
- Não é possível alugar um veículo que já esteja reservado
- Deve ser possível Cadastrar,Remover se não estiver reservado
- CRUD (Create, Read, Update, Delete)

  
#### Veículos:
| Função | Rota | Parametro | Tipo |
| ------ | ------ | ------ | ------ |
| Listar Todos | /veiculo | Nenhum | GET
| Exibir | /buscar/id | ID do Veículo | GET
| Cadastrar | /criar | JSON do Veículo | POST
| Editar | /atualizar/id | ID do Veículo | PUT
| Remover | /deletar/id| ID do Veículo | DELETE


#### Efetuar Reserva de Veículo:
| Função | Rota | Parametro | Tipo |
| ------ | ------ | ------ | ------ |
| Listar Todas | /reserva | Nenhum | GET
| Exibir | reserva| ID da Reserva | GET
| Cadastrar | /criar| JSON do Reserva | POST
| Editar | /reserva/id | ID do Reserva | PUT
| Remover | /cancelar/id_veiculo | ID do Reserva | DELETE
