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

### Vercel (conectada ao GitHub)

O site é 100% estático — sem build. Projeto conectado ao repositório `pipeelo/docs`: **todo push na `main` publica automaticamente**.

```bash
# na api, após mudar endpoints:
make docs-sync

# aqui:
git add openapi.json && git commit -m "Atualiza documentação" && git push
```

Configuração na Vercel (feita uma vez): Add New Project → Import `pipeelo/docs` → Framework **Other**, sem build command, output na raiz. Os headers de cache estão em `vercel.json` (spec sempre revalidado; bundle do Scalar imutável). Para domínio próprio (ex.: `docs.pipeelo.com`), adicione o domínio no painel e aponte o CNAME.

Deploy manual sem git, se precisar: `npx vercel --prod`.

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
