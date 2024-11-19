CREATE OR REPLACE FUNCTION atualizar_saldo_devedor_ao_pagar_parcela()
RETURNS TRIGGER AS $$
BEGIN
  
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE  OR REPLACE TRIGGER trigger_atualizar_saldo_parcela
AFTER UPDATE ON parcela
FOR EACH ROW
EXECUTE FUNCTION atualizar_saldo_devedor_ao_pagar_parcela();
