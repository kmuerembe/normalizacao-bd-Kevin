# Normalização de Base de Dados — Sistema de Gestão de Funcionários

**Trabalho II** — Universidade Licungo, Faculdade de Ciências e Tecnologias, Curso de Licenciatura em Informática.

## Sobre o projeto

Este repositório documenta o processo de normalização (1FN → 4FN) de uma tabela de funcionários originalmente mantida numa única folha de cálculo, com dados não atómicos, grupos repetitivos e dependências transitivas/multivaloradas.

## Estrutura do repositório

```
├── documentos/
│   └── analise-normalizacao.md   # Análise dos problemas e justificação de cada forma normal (1FN-4FN)
├── diagramas/
│   └── mer.mmd                   # Modelo Entidade-Relacionamento (formato Mermaid)
├── sql/
│   ├── schema.sql                # DDL - criação de todas as tabelas do esquema final
│   ├── dados_exemplo.sql         # Dados de exemplo para popular as tabelas
│   └── queries.sql               # Queries de exemplo (JOIN) que reconstituem a informação original
└── README.md
```

## Como consultar

1. **Análise da normalização:** ler `documentos/analise-normalizacao.md` — explica passo a passo os problemas identificados na tabela original e as decisões tomadas em cada forma normal.
2. **Modelo ER:** o ficheiro `diagramas/mer.mmd` pode ser visualizado em [mermaid.live](https://mermaid.live) ou em qualquer editor com suporte a Mermaid (ex.: preview do GitHub/VSCode).
3. **Base de dados:** executar `sql/schema.sql` para criar as tabelas, depois `sql/dados_exemplo.sql` para inserir dados, e por fim `sql/queries.sql` para ver as consultas de reconstituição.

## Esquema final (resumo)

- `Cidade(NomeCidade, Provincia, Pais)`
- `Cargo(CodCargo, DescricaoCargo)`
- `Funcao(CodFuncao, DescricaoFuncao)`
- `Funcionario(NUIT, Nome, DataNasc, BI, Email, Via, Numero, Bairro, NomeCidade→Cidade, CodCargo→Cargo, CodFuncao→Funcao, PostoTrabalho, DataAdmissao)`
- `Filho(NUIT→Funcionario, NomeFilho)`
- `Telefone(NUIT→Funcionario, NumeroCelular)`

## Vídeo explicativo

[Link do vídeo a adicionar aqui]
