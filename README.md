# BatePonto

Sistema de Frequência Eletrônica com interface web, API Next.js e banco de dados MySQL.

## Executar com Docker Compose

Pré-requisitos: Git e Docker Desktop com Docker Compose.

Clone o repositório, entre na pasta do projeto e inicie os serviços:

```bash
git clone https://github.com/milenamitie/bate-ponto.git
cd bate-ponto
docker compose up -d --build
```

Abra o site em **[http://localhost:8080](http://localhost:8080)**. No Docker Desktop, também é possível clicar na porta publicada `8080:3000` do container `app-bateponto`.

O Compose constrói a aplicação a partir do código deste repositório e inicia o MySQL. A aplicação e a API rodam no container `app-bateponto`; o banco usa a imagem [`milenamitie/mysql-bateponto`](https://hub.docker.com/r/milenamitie/mysql-bateponto).

### Portas

- Site e API: `http://localhost:8080`
- MySQL: `localhost:3307` (porta `3306` dentro do container)

### Comandos úteis

```bash
docker compose ps
docker compose logs -f app-bateponto
docker compose down
```

`docker compose down` mantém os dados do banco no volume. Para apagar o banco persistido e recriá-lo na próxima inicialização, use `docker compose down -v`. Os scripts de demonstração são executados somente quando o volume do MySQL é inicializado pela primeira vez.

As credenciais padrão são destinadas somente a demonstrações locais. Antes de disponibilizar o sistema em uma rede, crie um arquivo `.env` na raiz com valores próprios para `MYSQL_ROOT_PASSWORD`, `DB_PASSWORD` e `SESSION_SECRET`; não publique esse arquivo.

## Desenvolvimento local

Instale as dependências e inicie o servidor Next.js:

```bash
npm ci
npm run dev
```

O servidor de desenvolvimento fica disponível em [http://localhost:3000](http://localhost:3000). Configure as variáveis de conexão MySQL no ambiente antes de iniciar.
