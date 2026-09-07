# Normalização de Base de Dados — Sistema de Gestão de Funcionários

Universidade Licungo — Faculdade de Ciências e Tecnologias
Curso de Licenciatura em Informática — Trabalho II

## 1. Identificação dos problemas na tabela original (0FN)

A tabela original guarda todos os dados de 16 funcionários numa única folha, o que gera três tipos de problema:

### 1.1 Dados não atómicos

A coluna **`Endereço`** junta várias informações distintas num só campo de texto (ex.: `"Av. Julius Nyerere, n.º 245, Sommerschield"`). Isto impede, por exemplo, pesquisar todos os funcionários de um determinado bairro sem recorrer a manipulação de texto. Deve ser dividida em `Via`, `Número` e `Bairro`.

### 1.2 Grupos repetitivos

As colunas **`Filho1/Filho2/Filho3`** e **`Celular1/Celular2/Celular3`** representam o mesmo tipo de informação repetida em colunas fixas. Isto causa:
- **Anomalia de inserção:** um funcionário com 4 filhos não pode ser representado.
- **Desperdício de espaço:** funcionários com 0 ou 1 filho deixam colunas vazias.
- **Dificuldade de consulta:** contar "quantos filhos tem cada funcionário" exige verificar 3 colunas.

### 1.3 Dependências

- **Transitiva (Cargo/Função):** o enunciado confirma que os códigos `Cód. Cargo` e `Cód. Função` se repetem entre vários funcionários (ex.: `C01` aparece para Amélia e Ivete). Logo, `Cargo` não depende do funcionário, depende do `Cód. Cargo`: `NUIT → Cód.Cargo → Cargo`.
- **Transitiva (Localização):** a mesma cidade repete-se em vários funcionários sempre com a mesma província e país (ex.: "Maputo" → sempre "Maputo Cidade" → sempre "Moçambique"): `NUIT → Cidade → Província → País`.
- **Multivalorada independente:** o número de filhos e o número de contactos telefónicos de um funcionário são factos **independentes** um do outro — não há relação entre "quantos filhos" e "quantos telefones" tem uma pessoa. Se forem colocados juntos numa única tabela achatada, geram-se combinações artificiais (produto cartesiano) entre filhos e telefones que não existem na realidade.

---

## 2. 1.ª Forma Normal (1FN)

**Ação:** eliminar grupos repetitivos e garantir atomicidade. Cada linha repetida de filho/celular passa a ser uma linha própria, e o endereço é dividido.

Resultado (tabela única, ainda não ideal — chave composta):

\```
Funcionario_Detalhe(NUIT, Nome, DataNasc, BI, Email, Via, Número, Bairro,
                     Cidade, Província, País, Cargo, CódCargo, Função,
                     CódFunção, PostoTrabalho, DataAdmissão, Filho, Celular)
\```

Já não há colunas repetidas nem dados compostos — mas a tabela ainda mistura factos independentes (filhos e celulares) e tem muita redundância (todos os dados pessoais repetem-se em cada combinação filho×celular).

---

## 3. 2.ª Forma Normal (2FN)

**Ação:** eliminar dependências parciais em relação à chave primária. A chave de `Funcionario_Detalhe` é composta (NUIT + Filho + Celular), mas atributos como `Nome`, `Email`, `Cargo`, etc. dependem apenas de `NUIT` — dependência parcial.

Separação:

\```
Funcionario(NUIT, Nome, DataNasc, BI, Email, Via, Número, Bairro,
            Cidade, Província, País, Cargo, CódCargo, Função,
            CódFunção, PostoTrabalho, DataAdmissão)

Funcionario_Filho_Celular(NUIT, Filho, Celular)
\```

A segunda tabela ainda mistura os dois factos multivalorados — problema resolvido só na 4FN.

---

## 4. 3.ª Forma Normal (3FN)

**Ação:** eliminar dependências transitivas em `Funcionario`.

\```
Cargo(CódCargo PK, DescriçãoCargo)
Função(CódFunção PK, DescriçãoFunção)
Cidade(NomeCidade PK, Província, País)

Funcionario(NUIT PK, Nome, DataNasc, BI, Email, Via, Número, Bairro,
            NomeCidade FK, CódCargo FK, CódFunção FK,
            PostoTrabalho, DataAdmissão)
\```

Agora `Cargo`, `Função` e `Cidade` (com a sua província e país) só são guardados **uma vez** e referenciados por chave estrangeira.

---

## 5. 4.ª Forma Normal (4FN)

**Ação:** eliminar a dependência multivalorada independente entre filhos e telefones, separando-os em duas tabelas independentes.

\```
Filho(NUIT FK, NomeFilho)          -- PK (NUIT, NomeFilho)
Telefone(NUIT FK, NúmeroCelular)   -- PK (NUIT, NúmeroCelular)
\```

---

## 6. Esquema final (após 4FN)

| Tabela | Chave Primária | Chaves Estrangeiras |
|---|---|---|
| `Cidade` | NomeCidade | — |
| `Cargo` | CódCargo | — |
| `Função` | CódFunção | — |
| `Funcionario` | NUIT | NomeCidade, CódCargo, CódFunção |
| `Filho` | (NUIT, NomeFilho) | NUIT |
| `Telefone` | (NUIT, NúmeroCelular) | NUIT |

## 7. Cardinalidades

| Relacionamento | Cardinalidade | Justificação |
|---|---|---|
| Funcionario — Cidade | N:1 | Vários funcionários podem viver na mesma cidade; cada funcionário mora numa só cidade |
| Funcionario — Cargo | N:1 | Vários funcionários podem ter o mesmo cargo |
| Funcionario — Função | N:1 | Vários funcionários podem ter a mesma função |
| Funcionario — Filho | 1:N | Um funcionário pode ter vários filhos; um filho pertence a um só funcionário (no registo) |
| Funcionario — Telefone | 1:N | Um funcionário pode ter vários contactos; cada contacto pertence a um funcionário |

> **Nota:** os dados de filhos e telefones reconstruídos em `sql/dados_exemplo.sql` foram derivados a partir do ficheiro de partida; confirma-os contra o teu Excel original antes da entrega, pois a extração de tabelas com múltiplas linhas por célula pode introduzir pequenos desalinhamentos.
