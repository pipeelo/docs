# Documentação da API Pipeelo

Site estático de referência da API, no estilo [Stripe API docs](https://docs.stripe.com/api). Renderiza o `openapi.json` com [Scalar](https://github.com/scalar/scalar) — três colunas, busca, dark mode e cliente de teste embutido.

## Rodar localmente

```bash
npm install
npm run vendor   # copia o bundle do Scalar para vendor/scalar (sem CDN)
npm run serve    # http://localhost:8020
```

## Atualizar a documentação

O `openapi.json` é **gerado automaticamente** a partir do código da API (`Projects/api`) — nunca edite manualmente. No repositório da API:

```bash
make docs-sync
```

Isso exporta o spec via Scramble, aplica o pós-processamento (grupos da sidebar, validação do mapa) e copia o resultado para cá.

### De onde vem o conteúdo

| Conteúdo | Fonte (em `Projects/api`) |
|---|---|
| Endpoints documentados (allowlist) | `docs/api-descriptions.php` |
| Resumos, descrições, tags, schemas de resposta | `docs/api-descriptions.php` |
| Introdução (autenticação, paginação, erros) | `docs/api-intro.md` |
| Schemas de request | Inferidos dos FormRequests |
| Grupos da sidebar | `tagGroups` no mapa + `docs/postprocess-openapi.php` |

## Deploy

### Easypanel (produção, desde 10/09/2026)

`docs.pipeelo.com` roda no **Easypanel**, no mesmo VPS do resto da plataforma — serviço
`docs` do projeto `pipeelo`. Constrói o `Dockerfile` (nginx:alpine servindo os estáticos
na porta 8080); não há etapa de build de JS.

**Todo push na `main` publica.** Quem dispara é um webhook `push` do próprio repositório
apontando para a URL de deploy do serviço, e NÃO a integração GitHub↔Easypanel: o
`autoDeploy` do painel não fixa neste repo, porque o app do GitHub do Easypanel não tem
acesso a ele. O webhook é o caminho que funciona — não o troque por `autoDeploy` sem
conferir que fixou.

```bash
# na api, após mudar endpoints:
make docs-sync

# aqui:
git add openapi.json && git commit -m "Atualiza documentação" && git push
```

Deploy manual, se precisar: botão **Deploy** no painel do serviço, ou um `POST` na URL de
deploy (a mesma do webhook, visível em Easypanel → projeto `pipeelo` → `docs`).

Os headers de cache moram no `nginx.conf` — spec sempre revalidado, bundle do Scalar
imutável por um ano, assets por um dia.

> **Migramos da Vercel em 10/09/2026.** O motivo foi concreto: um push na `main` parou de
> publicar e o site ficou servindo a versão antiga sem nenhum erro visível. O `vercel.json`
> continua no repo só como referência dos headers; a Vercel não é mais a origem de
> `docs.pipeelo.com`.

### Docker (rodar em qualquer lugar)

```bash
docker compose up -d   # nginx servindo em http://localhost:8021
```

É o mesmo `Dockerfile` que o Easypanel constrói, então o que roda local é o que vai pro ar.

## Atualizar o Scalar

```bash
npm update @scalar/api-reference
npm run vendor
```
