--
-- Porta Lógica AND descrjta em VHDL
--
-- Duas entradas: a e b
--
-- Uma saída: o
--
-- Autor: Pedro Falcão
-- Data: Fevereiro de 2019

library ieee; -- Bibliotecas do Instituto de Engenheiros Elétricos e Eletrônicos
use ieee.std_logic_1164.all; -- Biblioteca padrão 1165

entity my_and is port			-- Declaraçao da entidade
	(
	  a	:  in  std_logic;				-- entrada digital a
	  b	:  in  std_logic;				-- entrada digital b
	  o	:  out std_logic				-- saída digital o

	);
	end my_and;							-- final da declaraçao da entidade

	-- início da arquitetura
	architecture hardware of my_and is
	begin									-- inicia o hardware

	o <= a AND b;						-- saida o recebe a operaçao lógica E com b

	end hardware;						-- final do hardware
