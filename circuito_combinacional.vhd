--
-- Circuito combinacional
--
-- três entradas: a,b e c.
--
-- Uma saída: Out
--
--Equação OUT=~A~B+~B~C+A~C
-- Autor: Pedro Falcão
-- Data: Fevereiro de 2019

library ieee; -- Bibliotecas do Instituto de Engenheiros Elétricos e Eletrônicos
use ieee.std_logic_1164.all; -- Biblioteca padrão 1165

entity circuito_combinacional is port
(

  a: in std_logic;
  b: in std_logic;
  c: in std_logic;
  o: out std_logic

);
end circuito_combinacional
architecture hardware of circuito_combinacional is
signal or1 : std_logic;
signal or2 : std_logic;
signal or3 : std_logic;
  begin
  or1 <= (not A) and (not B);
  or2 <= (not B) and (not C);
  or3 <= (A)     and (not C);
  o   <= (or1 or or2 or or3);
  end hardware
