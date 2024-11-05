CREATE TABLE aquisicao_produto (
    aquisicao_codigo SERIAL PRIMARY KEY,
    produto_codigo INTEGER REFERENCES produto(produto_codigo),
    quantidade INTEGER,
    data_aquisicao DATE DEFAULT CURRENT_DATE
);

CREATE OR REPLACE FUNCTION atualizar_estoque_ao_adquirir()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE produto
    SET estoque = estoque + NEW.quantidade
    WHERE produto_codigo = NEW.produto_codigo;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_estoque_aquisicao
AFTER INSERT ON aquisicao_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque_ao_adquirir();
