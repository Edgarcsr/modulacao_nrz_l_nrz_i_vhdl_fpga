library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_l is
    Generic (
        DATA_WIDTH    : integer := 16;       -- data size to be read
        TICKS_PER_BIT : integer := 100000000 -- clk cycles per bit (1 Hz base 100MHz)
    );
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        data_in : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0); -- payload (switches)
        nrz_out : out STD_LOGIC;                                 -- serial tx line (LED 0)
        tx_pmod : out STD_LOGIC;                                 -- Oscilloscope output (Pmod JA1)
        bit_idx : out integer range 0 to DATA_WIDTH - 1;         -- debugging (LEDs 12-15)
        
        -- VGA Ports (4 bits por cor + Sync)
        vga_r   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_g   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_b   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_hs  : out STD_LOGIC;
        vga_vs  : out STD_LOGIC
    );
end nrz_l;

architecture Behavioral of nrz_l is
    -- =======================================================
    -- NRZ-L Signals
    -- =======================================================
    signal bit_ptr      : integer range 0 to DATA_WIDTH - 1 := DATA_WIDTH - 1;
    signal tick_counter : integer range 0 to TICKS_PER_BIT - 1 := 0;
    signal current_bit  : STD_LOGIC := '0';

    -- =======================================================
    -- VGA Timing Signals (640x480 @ 60Hz require 25 MHz pixel clock)
    -- =======================================================
    signal clk_div25  : integer range 0 to 3 := 0;
    signal vga_clk_en : boolean := false;
    signal h_cnt      : integer range 0 to 799 := 0;
    signal v_cnt      : integer range 0 to 524 := 0;

    -- VGA 640x480 Parameters
    constant H_ACTIVE : integer := 640;
    constant H_FP     : integer := 16;
    constant H_SYNC   : integer := 96;
    constant H_BP     : integer := 48;
    
    constant V_ACTIVE : integer := 480;
    constant V_FP     : integer := 10;
    constant V_SYNC   : integer := 2;
    constant V_BP     : integer := 33;

begin
    -- =======================================================
    -- NRZ-L Transmitter Logic (Lógica Principal de Transmissão)
    -- =======================================================
    process(clk, reset)
    begin
        if reset = '1' then
            bit_ptr <= DATA_WIDTH - 1;
            tick_counter <= 0;
        elsif rising_edge(clk) then
            if tick_counter < TICKS_PER_BIT - 1 then
                tick_counter <= tick_counter + 1;
            else
                tick_counter <= 0;
                if bit_ptr = 0 then
                    bit_ptr <= DATA_WIDTH - 1;
                else
                    bit_ptr <= bit_ptr - 1;
                end if;
            end if;
        end if;
    end process;

    -- Espelha o bit atual nas saídas digitais e analógicas
    current_bit <= data_in(bit_ptr);
    nrz_out     <= current_bit;
    tx_pmod     <= current_bit;
    bit_idx     <= bit_ptr;

    -- =======================================================
    -- VGA Controller Logic (Lógica do Monitor)
    -- =======================================================
    
    -- 1. Divisor de Clock (Gera pulso de enable de 25 MHz a partir dos 100 MHz)
    process(clk)
    begin
        if rising_edge(clk) then
            if clk_div25 = 3 then
                clk_div25 <= 0;
                vga_clk_en <= true;
            else
                clk_div25 <= clk_div25 + 1;
                vga_clk_en <= false;
            end if;
        end if;
    end process;

    -- 2. Contadores Horizontal e Vertical do VGA
    process(clk, reset)
    begin
        if reset = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif rising_edge(clk) then
            if vga_clk_en then
                if h_cnt = 799 then
                    h_cnt <= 0;
                    if v_cnt = 524 then
                        v_cnt <= 0;
                    else
                        v_cnt <= v_cnt + 1;
                    end if;
                else
                    h_cnt <= h_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- 3. Geração dos Sinais de Sincronização e Cores
    process(clk)
    begin
        if rising_edge(clk) then
            -- Sincronismo Horizontal (Ativo baixo no padrão 640x480)
            if (h_cnt >= H_ACTIVE + H_FP) and (h_cnt < H_ACTIVE + H_FP + H_SYNC) then
                vga_hs <= '0';
            else
                vga_hs <= '1';
            end if;

            -- Sincronismo Vertical (Ativo baixo)
            if (v_cnt >= V_ACTIVE + V_FP) and (v_cnt < V_ACTIVE + V_FP + V_SYNC) then
                vga_vs <= '0';
            else
                vga_vs <= '1';
            end if;

            -- Pinta a tela de acordo com o bit atual (se estiver na área visível)
            if (h_cnt < H_ACTIVE) and (v_cnt < V_ACTIVE) then
                if current_bit = '1' then
                    -- Tela Verde para bit '1'
                    vga_r <= "0000";
                    vga_g <= "1111";
                    vga_b <= "0000";
                else
                    -- Tela Vermelha para bit '0'
                    vga_r <= "1111";
                    vga_g <= "0000";
                    vga_b <= "0000";
                end if;
            else
                -- Zera os dados de cor na área de blanking (obrigatório para o VGA funcionar corretamente)
                vga_r <= "0000";
                vga_g <= "0000";
                vga_b <= "0000";
            end if;
        end if;
    end process;

end Behavioral;