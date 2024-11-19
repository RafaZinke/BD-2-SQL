-- Criar ou substituir a função da trigger
CREATE OR REPLACE FUNCTION atualizar_valor_atendimento()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualizar o valor do atendimento somando o valor da vacinação
    UPDATE atendimento
    SET valor = valor + (
        SELECT valor
        FROM vacina
        WHERE vacina_codigo = NEW.vacina_codigo
    )
    WHERE atendimento_sequencia = NEW.atendimento_sequencia;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar a trigger que chama a função ao inserir uma vacinação
CREATE TRIGGER trigger_atualizar_valor_atendimento
AFTER INSERT ON atendimento_vacina
FOR EACH ROW
EXECUTE FUNCTION atualizar_valor_atendimento();
