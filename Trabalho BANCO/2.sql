CREATE OR REPLACE FUNCTION atualizar_valor_atendimento_ao_incluir_produto_servico()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_TABLE_NAME = 'atendimento_produto' THEN
        UPDATE atendimento
        SET valor = valor_total + (SELECT valor FROM produto WHERE produto_codigo = NEW.produto_codigo) * NEW.quantidade
        WHERE atendimento_sequencia = NEW.atendimento_sequencia;
    ELSIF TG_TABLE_NAME = 'atendimento_servico' THEN
        UPDATE atendimento
        SET valor = valor + (SELECT valor FROM servico WHERE servico_codigo = NEW.servico_codigo) * NEW.quantidade
        WHERE atendimento_sequencia = NEW.atendimento_sequencia;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_valor_atendimento_produto
AFTER INSERT ON atendimento_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_valor_atendimento_ao_incluir_produto_servico();

CREATE TRIGGER trigger_atualizar_valor_atendimento_servico
AFTER INSERT ON atendimento_servico
FOR EACH ROW
EXECUTE FUNCTION atualizar_valor_atendimento_ao_incluir_produto_servico();
