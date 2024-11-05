CREATE OR REPLACE FUNCTION atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE produto
        SET estoque = estoque - NEW.quantidade
        WHERE produto_codigo = NEW.produto_codigo;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE produto
        SET estoque = estoque - (NEW.quantidade - OLD.quantidade)
        WHERE produto_codigo = NEW.produto_codigo;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE produto
        SET estoque = estoque + OLD.quantidade
        WHERE produto_codigo = OLD.produto_codigo;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_estoque_inserir
AFTER INSERT ON atendimento_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();

CREATE TRIGGER trigger_atualizar_estoque_atualizar
AFTER UPDATE ON atendimento_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();

CREATE TRIGGER trigger_atualizar_estoque_excluir
AFTER DELETE ON atendimento_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();
