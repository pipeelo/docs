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

### Vercel (recomendado)

O site é 100% estático — sem build. Primeira vez:

```bash
npx vercel login
npx vercel          # cria o projeto (aceite os padrões; framework: Other, sem build command)
npx vercel --prod
```

Atualizações depois do `make docs-sync`:

```bash
npx vercel --prod
```

Os headers de cache estão em `vercel.json` (spec sempre revalidado; bundle do Scalar imutável). Para domínio próprio (ex.: `docs.pipeelo.com`), adicione o domínio no painel da Vercel e aponte o CNAME.

> O plano free da Vercel é oficialmente para uso não-comercial. Alternativa com free tier sem essa restrição: Cloudflare Pages (mesmo fluxo, sem build).

### Docker (alternativa self-host)

```bash
docker compose up -d   # nginx servindo em http://localhost:8021
```

O `Dockerfile` (nginx:alpine + estáticos com gzip e cache) serve para subir no ECS/qualquer host Docker, no mesmo fluxo ECR da API.

## Atualizar o Scalar

```bash
npm update @scalar/api-reference
npm run vendor
```
