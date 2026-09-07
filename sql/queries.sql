-- ============================================================
-- Queries de exemplo: reconstituição da informação original
-- a partir do esquema normalizado
-- ============================================================

-- 1. Ficha completa do funcionário (dados pessoais + cargo + função + morada)
--    Reconstitui as colunas: Nome, Cargo, Função, Cidade, Província, País
SELECT
    f.NUIT,
    f.Nome,
    f.Email,
    f.Via,
    f.Numero,
    f.Bairro,
    c.NomeCidade,
    c.Provincia,
    c.Pais,
    cg.DescricaoCargo AS Cargo,
    fn.DescricaoFuncao AS Funcao,
    f.PostoTrabalho,
    f.DataAdmissao
FROM Funcionario f
JOIN Cidade c  ON f.NomeCidade = c.NomeCidade
JOIN Cargo cg  ON f.CodCargo   = cg.CodCargo
JOIN Funcao fn ON f.CodFuncao  = fn.CodFuncao;

-- 2. Funcionário com todos os seus filhos
--    Reconstitui as colunas Filho1, Filho2, Filho3 (agora em linhas)
SELECT
    f.Nome,
    fi.NomeFilho
FROM Funcionario f
JOIN Filho fi ON f.NUIT = fi.NUIT
ORDER BY f.Nome;

-- 3. Funcionário com todos os seus contactos telefónicos
--    Reconstitui as colunas Celular1, Celular2, Celular3 (agora em linhas)
SELECT
    f.Nome,
    t.NumeroCelular
FROM Funcionario f
JOIN Telefone t ON f.NUIT = t.NUIT
ORDER BY f.Nome;

-- 4. (Extra) Contagem de filhos e telefones por funcionário
--    Demonstra que filhos e telefones são independentes (4FN)
SELECT
    f.Nome,
    COUNT(DISTINCT fi.NomeFilho)      AS Num_Filhos,
    COUNT(DISTINCT t.NumeroCelular)   AS Num_Telefones
FROM Funcionario f
LEFT JOIN Filho fi     ON f.NUIT = fi.NUIT
LEFT JOIN Telefone t   ON f.NUIT = t.NUIT
GROUP BY f.Nome;
