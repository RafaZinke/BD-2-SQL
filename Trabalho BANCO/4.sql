CREATE OR REPLACE FUNCTION atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica a operação que acionou a trigger
    IF TG_OP = 'INSERT' THEN
        -- Reduz o estoque com base na quantidade do novo registro
        UPDATE produto
        SET estoque = estoque - NEW.quantidade
        WHERE produto_codigo = NEW.produto_codigo;

    ELSIF TG_OP = 'UPDATE' THEN
        -- Ajusta o estoque considerando a diferença entre a nova e a antiga quantidade
        UPDATE produto
        SET estoque = estoque - (NEW.quantidade - OLD.quantidade)
        WHERE produto_codigo = NEW.produto_codigo;

    ELSIF TG_OP = 'DELETE' THEN
        -- Reverte a quantidade excluída ao estoque
        UPDATE produto
        SET estoque = estoque + OLD.quantidade
        WHERE produto_codigo = OLD.produto_codigo;
    END IF;

    -- Retorna a linha nova ou nula dependendo da operação
    IF TG_OP = 'DELETE' THEN
        RETURN OLD; -- Retorna OLD para DELETE
    ELSE
        RETURN NEW; -- Retorna NEW para INSERT/UPDATE
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Criação de uma única trigger que responde a INSERT, UPDATE e DELETE
CREATE or replace TRIGGER trigger_atualizar_estoque
AFTER INSERT OR UPDATE OR DELETE ON atendimento_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();
