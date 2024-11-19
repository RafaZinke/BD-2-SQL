CREATE OR REPLACE FUNCTION atualizar_saldo_devedor_ao_pagar_parcela()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'pago' THEN
        UPDATE tutor
        SET saldodevedor = saldodevedor - NEW.valor_pago
        WHERE tutor_codigo = (SELECT tutor_codigo FROM animal JOIN atendimento ON animal.animal_codigo = atendimento.animal_codigo WHERE atendimento.atendimento_sequencia = NEW.atendimento_sequencia);
    ELSIF NEW.status = 'aberto' THEN
        UPDATE tutor
        SET saldodevedor = saldodevedor + OLD.valor_pago
        WHERE tutor_codigo = (SELECT tutor_codigo FROM animal JOIN atendimento ON animal.animal_codigo = atendimento.animal_codigo WHERE atendimento.atendimento_sequencia = NEW.atendimento_sequencia);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_saldo_parcela
AFTER UPDATE ON parcela
FOR EACH ROW
EXECUTE FUNCTION atualizar_saldo_devedor_ao_pagar_parcela();
