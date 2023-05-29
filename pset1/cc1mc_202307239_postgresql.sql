-- Apaga o banco de dados "uvv" (caso exista).
DROP DATABASE IF EXISTS uvv;

-- Apaga o usuário "antonio" caso já exista.
DROP USER IF EXISTS antonio; 

-- Cria o usuário "antonio", sua senha e concede as permissões de criar um banco de dados e de criar novos roles 
CREATE USER antonio WITH PASSWORD '230305ant' CREATEDB CREATEROLE;

-- Cria o banco de dados com as designações corretas conforme o PSET.
 CREATE DATABASE uvv OWNER antonio 
 TEMPLATE template0 
 ENCODING 'UTF8' 
 LC_COLLATE 'pt_BR.UTF-8'
 LC_CTYPE 'pt_BR.UTF-8' 
 ALLOW_CONNECTIONS true;
 COMMENT ON DATABASE uvv IS 'Banco de dados lojas UVV.';

 -- Dá permissão de acesso ao usuário
 \setenv PGPASSWORD '230305ant' 
 \c uvv antonio
 
 -- Cria o schema "lojas" e o schema "public"
CREATE SCHEMA lojas; 

-- Concede acesso e a permissão para criar tabelas e colunas dentro schema "lojas" para o usuário "antonio".
GRANT USAGE ON SCHEMA lojas TO antonio;
GRANT CREATE ON SCHEMA lojas TO antonio;

-- Altera a sequência dos schemas do usuário "antonio" (Da sessão atual).
SET SEARCH_PATH TO lojas, "$user", public;

-- Altera a sequência dos schemas do usuário "antonio" (Para sessões futuras).
ALTER USER antonio
SET SEARCH_PATH TO lojas, "$user", public;

                                    -- Criação das tabelas e colunas: --

/* Os conteúdos referentes ao banco de dados são relacionados às lojas da Universidade Vila Velha. O banco de dados contém os registros das lojas, dos clientes, dos produtos, do estoque de cada loja, dos itens comprados, do status do envio, entre outros. O banco de dados foi desenvolvido no PostgreSQL.
*/ 

-- Cria a tabela "produtos", as colunas da tabela e a PK da tabela.
CREATE TABLE produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_pedido_id PRIMARY KEY (produto_id)
);

-- Adiciona uma restrição a coluna "imagem_ultima_atualizacao" impedindo a inserção de uma data futura no sistema.
ALTER TABLE produtos
ADD CONSTRAINT imagem_ultima_atualizacao_check CHECK (imagem_ultima_atualizacao <= CURRENT_DATE);

--Adiciona uma restrição a coluna "preco_unitario" impedindo a inserção de um valor negativo.
ALTER TABLE produtos
ADD CONSTRAINT preco_unitario_check CHECK (preco_unitario >= 0);

-- Adiciona os comentários sobre a tabela "produtos" e suas respectivas colunas.
COMMENT ON TABLE produtos IS 'Tabela de produtos, registra os produtos de cada loja.';
COMMENT ON COLUMN produtos.produto_id IS 'Primary key da tabela produtos. Registra o número de identificação dos produtos no sistema.';
COMMENT ON COLUMN produtos.nome IS 'Registra os nomes de cada produto.';
COMMENT ON COLUMN produtos.preco_unitario IS 'Registra o preço de cada produto.';
COMMENT ON COLUMN produtos.detalhes IS 'Registra os detalhes de cada produto.';
COMMENT ON COLUMN produtos.imagem IS 'Registra as imagens de cada produto.';
COMMENT ON COLUMN produtos.imagem_mime_type IS 'Registra as imagens de cada produto em MIME (usado para identificar o tipo de conteúdo de um arquivo transmitido pela Internet.)';
COMMENT ON COLUMN produtos.imagem_arquivo IS 'Registra os arquivos de imagem de cada produto.';
COMMENT ON COLUMN produtos.imagem_charset IS 'Registra a codificação das imagens de cada produto';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao IS 'Registra a data da última atualização das imagens de cada produto.';

-- Cria a tabela "lojas", as colunas da tabela e a PK da tabela.
CREATE TABLE lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_loja_id PRIMARY KEY (loja_id)
);

-- Adiciona uma restrição as colunas "endereco_fisico" e "endereco_web" impedindo que as colunas fiquem nulas.
ALTER TABLE lojas
ADD CONSTRAINT check_endereco
CHECK (endereco_fisico IS NOT NULL OR endereco_web IS NOT NULL);

-- Adiciona uma restrição a coluna "logo_ultima_atualizacao" impedindo a inserção de uma data futura no sistema.
ALTER TABLE lojas
ADD CONSTRAINT logo_ultima_atualizacao_check CHECK (logo_ultima_atualizacao <= CURRENT_DATE);

-- Adiciona os comentários sobre a tabela "lojas" e suas respectivas colunas.
COMMENT ON TABLE lojas IS 'Tabela de lojas, registra  o endereço de cada loja.';
COMMENT ON COLUMN lojas.loja_id IS 'Primary key da tabela. Registra o número de identificação das lojas no sistema.';
COMMENT ON COLUMN lojas.nome IS 'Registra o nome de cada loja.';
COMMENT ON COLUMN lojas.endereco_web IS 'Registra a URL do site das lojas.';
COMMENT ON COLUMN lojas.endereco_fisico IS 'Registra o endereço de cada loja.';
COMMENT ON COLUMN lojas.latitude IS 'Registra as coordenadas latitudinais de cada loja.';
COMMENT ON COLUMN lojas.longitude IS 'Registra as coordenadas longitudinais de cada loja.';
COMMENT ON COLUMN lojas.logo IS 'Registra a logo da loja em arquivo BLOB';
COMMENT ON COLUMN lojas.logo_mime_type IS 'Registra a logo de cada loja em MIME (usado para identificar o tipo de conteúdo de um arquivo transmitido pela Internet.)';
COMMENT ON COLUMN lojas.logo_arquivo IS 'Registra o arquivo da logo de cada loja.';
COMMENT ON COLUMN lojas.logo_charset IS 'Registra a codificação da logo de cada loja.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao IS 'Registra a data da última atualização da logo de cada loja.';

-- Cria a tabela "estoques", as colunas da tabela e a PK da tabela.
CREATE TABLE estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoque_id PRIMARY KEY (estoque_id)
);

-- Adiciona uma restrição a coluna "quantidade" impedindo a inserção de um valor negativo.
ALTER TABLE estoques
ADD CONSTRAINT quantidade_check CHECK (quantidade >= 0);

-- Adiciona os comentários sobre a tabela "estoques" e suas respectivas colunas.
COMMENT ON TABLE estoques IS 'Tabela de estoques. Registra a quantidade do estoque de cada loja.';
COMMENT ON COLUMN estoques.estoque_id IS 'Primary key da tabela estoques. Registra o número de identificação dos estoques no sistema.';
COMMENT ON COLUMN estoques.loja_id IS 'Primary key da tabela. Registra o número de identificação das lojas no sistema.';
COMMENT ON COLUMN estoques.produto_id IS 'Primary key da tabela produtos. Registra o número de identificação dos produtos no sistema.';
COMMENT ON COLUMN estoques.quantidade IS 'Registra a quantidade de cada produto em estoque nas lojas.';

-- Cria a tabela "clientes", as colunas da tabela e a PK da tabela.
CREATE TABLE clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                Telefone1 VARCHAR(20),
                Telefone2 VARCHAR(20),
                Telefone3 VARCHAR(20),
                CONSTRAINT pk_cliente_id PRIMARY KEY (cliente_id)
);

-- Adiciona uma restrição na coluna "nome" impedindo a inserção de números.
ALTER TABLE clientes
ADD CONSTRAINT check_nome_no_numeros CHECK (nome ~ '^[^0-9]+$');

-- Adiciona os comentários sobre a tabela "clientes" e suas respectivas colunas.
COMMENT ON TABLE clientes IS 'Tabela de clientes, registra as informações do cadastro de cada cliente.';
COMMENT ON COLUMN clientes.cliente_id IS 'Primary key da tabela clientes. Registra o número de identificação do cliente no sistema.';
COMMENT ON COLUMN clientes.email IS 'Registra o e-mail do cliente';
COMMENT ON COLUMN clientes.nome IS 'Registra o nome do cliente. (Conforme RG)';
COMMENT ON COLUMN clientes.Telefone1 IS 'Registra o telefone do cliente.';
COMMENT ON COLUMN clientes.Telefone2 IS 'Registra o segundo telefone do cliente.';
COMMENT ON COLUMN clientes.Telefone3 IS 'Registra o terceiro telefone do cliente.';

-- Cria a tabela "envios", as colunas da tabela e a PK da tabela.
CREATE TABLE envios (
                envio_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envio_id PRIMARY KEY (envio_id)
);

--Adiciona uma restrição na coluna "status" impedindo a inserção de palavras além das mencionadas na restrição.
ALTER TABLE envios
ADD CONSTRAINT check_status
CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

-- Adiciona os comentários sobre a tabela "envios" e suas respectivas colunas.
COMMENT ON TABLE envios IS 'Tabela de envios. Registra as informações dos envios de cada pedido de cada loja.';
COMMENT ON COLUMN envios.envio_id IS 'Primary key da tabela envios. Registra o número de identificação dos envios no sistema.';
COMMENT ON COLUMN envios.cliente_id IS 'Primary key da tabela clientes. Registra o número de identificação do cliente no sistema.';
COMMENT ON COLUMN envios.loja_id IS 'Primary key da tabela. Registra o número de identificação das lojas no sistema.';
COMMENT ON COLUMN envios.endereco_entrega IS 'Registra o endereço de cada entrega de cada loja.';
COMMENT ON COLUMN envios.status IS 'Registra o status de cada envio de cada loja.';

-- Cria a tabela "pedidos", as colunas da tabela e a PK da tabela.
CREATE TABLE pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos_id PRIMARY KEY (pedido_id)
);

-- Adiciona uma restrição na coluna "status" impedindo a inserção de palavras além das mencionadas na restrição.
ALTER TABLE pedidos
ADD CONSTRAINT check_status
CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

-- Adiciona uma restrição na coluna "data_hora" impedindo a inserção de uma data futura no sistema.
ALTER TABLE pedidos
ADD CONSTRAINT data_hora_check CHECK (data_hora <= CURRENT_TIMESTAMP);

-- Adiciona os comentários sobre a tabela "pedidos" e suas respectivas colunas.
COMMENT ON TABLE pedidos IS 'Tabela de pedidos, registra todas as informações sobre os pedidos feitos na loja.
';
COMMENT ON COLUMN pedidos.pedido_id IS 'Primary key da tabela pedidos. Registra o número de identificação do pedido no sistema.';
COMMENT ON COLUMN pedidos.cliente_id IS 'Primary key da tabela. Registra o número de identificação do cliente no sistema.';
COMMENT ON COLUMN pedidos.data_hora IS 'Registra a data e hora em que o pedido foi feito.';
COMMENT ON COLUMN pedidos.status IS 'Registra o status do pedido.';
COMMENT ON COLUMN pedidos.loja_id IS 'Primary key da tabela. Registra o número de identificação das lojas no sistema.';

-- Cria a tabela "pedidos_itens", as colunas da tabela e a PK da tabela.
CREATE TABLE pedidos_itens (
                produto_id NUMERIC(38) NOT NULL,
                pedido_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pfk_pedido_id__pfk_produto_id PRIMARY KEY (produto_id, pedido_id)
);

-- Adiciona uma restrição a coluna "preco_unitario" impedindo a inserção de um valor negativo.
ALTER TABLE pedidos_itens
ADD CONSTRAINT preco_unitario_check CHECK (preco_unitario >= 0);
-- Adiciona uma restrição a coluna "quantidade" impedindo a inserção de um valor negativo.
ALTER TABLE pedidos_itens
ADD CONSTRAINT quantidade_check CHECK (quantidade >= 0);

-- Adiciona os comentários sobre a tabela "pedidos_itens" e suas respectivas colunas.
COMMENT ON TABLE pedidos_itens IS 'Tabela dos itens de envio, Registra os itens a serem enviados.';
COMMENT ON COLUMN pedidos_itens.produto_id IS 'Primary key da tabela produtos. Registra o número de identificação dos produtos no sistema.';
COMMENT ON COLUMN pedidos_itens.pedido_id IS 'Primary key da tabela pedidos. Registra o número de identificação do pedido no sistema.';
COMMENT ON COLUMN pedidos_itens.numero_da_linha IS 'Registra o número da linha de cada pedido feito.';
COMMENT ON COLUMN pedidos_itens.preco_unitario IS 'Preço de cada item de um pedido.';
COMMENT ON COLUMN pedidos_itens.quantidade IS 'Registra a quantidade de cada dos itens de um pedido.';
COMMENT ON COLUMN pedidos_itens.envio_id IS 'Primary key da tabela envios. Registra o número de identificação dos envios no sistema.';

                                    -- Relações entre as tabelas: --

/* Cria uma relação entre as tabelas "produtos" e "estoques". Garante que os dados da coluna na tabela "estoques" correspondam ao mesmos dados da coluna "produto_id" da tabela "produtos". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "protudos" e "pedidos_itens". Garante que os dados da coluna na tabela "pedidos_itens" correspondam ao mesmos dados da coluna "produto_id" da tabela "produtos". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "lojas" e "pedidos". Garante que os dados da coluna na tabela "pedidos" correspondam ao mesmos dados da coluna "loja_id" da tabela "lojas". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "lojas" e "envios". Garante que os dados da coluna na tabela "envios" correspondam ao mesmos dados da coluna "loja_id" da tabela "lojas". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "lojas" e "estoques". Garante que os dados da coluna na tabela "estoques" correspondam ao mesmos dados da coluna "loja_id" da tabela "lojas". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "clientes" e "pedidos". Garante que os dados da coluna na tabela "pedidos" correspondam ao mesmos dados da coluna "cliente_id" da tabela "clientes". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "clientes" e "envios". Garante que os dados da coluna na tabela "envios" correspondam ao mesmos dados da coluna "cliente_id" da tabela "clientes". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "envios" e "pedidos_itens". Garante que os dados da coluna na tabela "pedidos_itens" correspondam ao mesmos dados da coluna "envio_id" da tabela "envios". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/* Cria uma relação entre as tabelas "pedidos" e "pedidos_itens". Garante que os dados da coluna na tabela "pedidos_itens" correspondam ao mesmos dados da coluna "pedido_id" da tabela "pedidos". "ON DELETE NO ACTION" e "ON UPDATE NO ACTION" significam respectivamente que nenhuma exclusão e nenhuma atualização são realizadas automaticamente na tabela que possui a chave estrangeira quando uma atualização ocorre na tabela referenciada.
*/
ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
