CREATE OR REPLACE FUNCTION aplicar_desconto_produto()
RETURNS TRIGGER AS $$
DECLARE
    des NUMERIC;
BEGIN
    SELECT desconto INTO des FROM categoria WHERE categoria_codigo = (SELECT categoria_codigo FROM produto WHERE produto_codigo = NEW.produto_codigo);
    UPDATE atendimento
    SET valor = valor - ((SELECT valor FROM produto WHERE produto_codigo = NEW.produto_codigo) * des / 100) * NEW.quantidade
    WHERE atendimento_sequencia = NEW.atendimento_sequencia;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER trigger_aplicar_desconto_produto
AFTER INSERT ON atendimento_produto
FOR EACH ROW
EXECUTE FUNCTION aplicar_desconto_produto();

CREATE OR REPLACE FUNCTION aplicar_desconto_servico()
RETURNS TRIGGER AS $$
DECLARE
    des NUMERIC;
BEGIN
    SELECT desconto INTO des FROM tipo WHERE tipo_codigo = (SELECT tipo_codigo FROM servico WHERE servico_codigo = NEW.servico_codigo);
    UPDATE atendimento
    SET valor = valor - ((SELECT valor FROM servico WHERE servico_codigo = NEW.servico_codigo) * des / 100) * NEW.quantidade
    WHERE atendimento_sequencia = NEW.atendimento_sequencia;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE or replace TRIGGER trigger_aplicar_desconto_servico
AFTER INSERT ON atendimento_servico
FOR EACH ROW
EXECUTE FUNCTION aplicar_desconto_servico();
