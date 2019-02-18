---------------------------------------------------------------------------------------
--                            BUFFER
--                        --------------
--                   RX ->|            |-> H
--              DATA_IN ->|            |<- ACK_H
--             CLOCK_RX ->|            |
--             CREDIT_O <-|            |-> DATA_AV
--                        |            |-> DATA
--                        |            |<- DATA_ACK
--                        |            |
--                        |            |
--                        |            |=> SENDER
--                        |            |   all ports
--                        --------------
--
--  Quando o algoritmo de chaveamento resulta no bloqueio dos flits de um pacote,
--  ocorre uma perda de desempenho em toda rede de interconexao, porque os flits sao
--  bloqueados nao somente na chave atual, mas em todas as intermediarias.
--  Para diminuir a perda de desempenho foi adicionada uma fila em cada porta de
--  entrada da chave, reduzindo as chaves afetadas com o bloqueio dos flits de um
--  pacote. E importante observar que quanto maior for o tamanho da fila menor sera o
--  numero de chaves intermediarias afetadas.
--  As filas usadas contem dimensao e largura de flit parametrizaveis, para altera-las
--  modifique as constantes TAM_BUFFER e TAM_FLIT no arquivo "Phoenix_packet.vhd".
--  As filas funcionam como FIFOs circulares. Cada fila possui dois ponteiros: first e
--  last. First aponta para a posicao da fila onde se encontra o flit a ser consumido.
--  Last aponta para a posicao onde deve ser inserido o proximo flit.
---------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.HammingPack16.all;
use work.NoCPackage.all;

-- interface da Phoenix_buffer
entity Phoenix_buffer is
    port(
        clock       : in  std_logic;
        reset       : in  std_logic;
        clock_rx    : in  std_logic;
        rx          : in  std_logic;
        data_in     : in  regflit;
        credit_o    : out std_logic;
        h           : out std_logic; -- requisicao de chaveamento
        ack_h       : in  std_logic; -- resposta da requisicao de chaveamento
        data_av     : out std_logic;
        data        : out regflit;
        data_ack    : in  std_logic;
        sender      : out std_logic
    );    
end Phoenix_buffer;

architecture buffer_arch of Phoenix_buffer is

    type fila_out is (REQ_ROUTING, SEND_DATA);
    signal next_state, current_state : fila_out;
    
    signal pull: std_logic;
    signal bufferHead : regflit;
    signal has_data: std_logic;
    signal has_data_and_sending : std_logic;
    signal counter : integer;
    
    signal sending : std_logic;
    signal sent : std_logic;

begin

    circularFifoBuffer : entity work.fifo_buffer
        generic map(BUFFER_DEPTH => TAM_BUFFER ,
                    BUFFER_WIDTH => regflit'length)
        port map(
            reset =>     reset,
            clock =>     clock_rx,
            tail =>      data_in,
            push =>      rx,
            pull =>      pull,
            counter =>   counter,
            head =>      bufferHead
        );

    data <= bufferHead;
    data_av <= has_data_and_sending;
    credit_o <= '1' when (counter /= TAM_BUFFER or pull = '1') else '0';
    sender <= sending;
    h <= has_data and not sending;

    pull <= data_ack and has_data_and_sending;
    has_data <= '1' when (counter /= 0) else '0';
    has_data_and_sending <= has_data and sending;

    process(current_state, ack_h, sent)
    begin
        next_state <= current_state;
        case current_state is
            when REQ_ROUTING =>
                if ack_h = '1' then
                    next_state <= SEND_DATA;
                end if;

            when SEND_DATA =>
                if sent = '1' then
                    next_state <= REQ_ROUTING;
                end if;
        end case;
    end process;

    process(reset, clock)
    begin
        if reset = '1' then
            current_state <= REQ_ROUTING;
        elsif rising_edge(clock) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, sent)
    begin
        case current_state is
            when SEND_DATA =>
                sending <= not sent;
            when others =>
                sending <= '0';
        end case;
    end process;

    process(reset, clock)
        variable flit_index : integer;
        variable counter_flit : integer;
    begin
        if reset = '1' then
            sent <= '0';
        elsif rising_edge(clock) then
            if sending = '1' then
                if data_ack = '1' and has_data = '1' then
                    sent <= '0';
                    if flit_index = 1 then
                        counter_flit :=  to_integer(unsigned(bufferHead));
                    elsif counter_flit /= 1 then
                        counter_flit := counter_flit - 1;
                    else -- counter_flit = 1
                        sent <= '1';
                    end if;
                    flit_index := flit_index + 1;
                else
                end if;
            else
                flit_index := 0;
                counter_flit := 0;
                sent <= '0';
            end if;
        end if;
    end process;

end buffer_arch;