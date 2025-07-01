# crud_flutter_web

Projeto Flutter Web com backend em Spring Boot para um sistema CRUD (Criar, Ler, Atualizar, Deletar) de usuários.

## Getting Started

Este projeto é um ponto de partida para uma aplicação Flutter Web integrada com uma API REST em Spring Boot.

### Tecnologias usadas

- Flutter Web para frontend
- Spring Boot para backend
- MySQL para banco de dados
- Comunicação via HTTP com API REST

### Como rodar o projeto

1. Backend (Spring Boot):
   - Configure o banco MySQL e ajuste o `application.properties` com suas credenciais.
   - Execute o backend (`mvn spring-boot:run` ou via IDE).
   - API disponível em `http://localhost:8080`.

2. Frontend (Flutter Web):
   - No diretório do Flutter, rode:
     ```
     flutter run -d chrome
     ```
   - A aplicação abrirá no navegador e consumirá a API backend.

---

Se precisar de ajuda, abra uma issue no repositório.
