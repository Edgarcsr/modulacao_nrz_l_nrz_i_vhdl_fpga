library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nrz_vga_top is
    Generic (
        DATA_WIDTH    : integer := 16;
        TICKS_PER_BIT : integer := 100000000  -- 1 bit por segundo no clock de 100MHz
    );
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0); 
        nrz_out  : out STD_LOGIC; 
        bit_idx  : out integer range 0 to DATA_WIDTH - 1; 
        
        -- Portas VGA
        vgaRed   : out STD_LOGIC_VECTOR(3 downto 0);
        vgaGreen : out STD_LOGIC_VECTOR(3 downto 0);
        vgaBlue  : out STD_LOGIC_VECTOR(3 downto 0);
        Hsync    : out STD_LOGIC;
        Vsync    : out STD_LOGIC
    );
end nrz_vga_top;

architecture Behavioral of nrz_vga_top is

    -- Sinais do codificador NRZ-I
    signal bit_ptr      : integer range 0 to DATA_WIDTH - 1 := DATA_WIDTH - 1;
    signal tick_counter : integer range 0 to TICKS_PER_BIT - 1 := 0; 
    signal current_lvl  : std_logic := '0'; 
    signal nrz_signal   : std_logic := '0';

    -- Sinais do controlador VGA
    signal clk_25MHz : std_logic := '0';
    signal clk_div   : integer range 0 to 3 := 0;
    
    signal h_count   : integer range 0 to 799 := 0;
    signal v_count   : integer range 0 to 524 := 0;
    signal video_on  : std_logic := '0';

begin

    -- Expõe os sinais internos para os LEDs
    nrz_out <= nrz_signal;
    bit_idx <= bit_ptr;

    -- ==========================================
    -- 1. Lógica do NRZ-I (Clock de 100 MHz)
    -- ==========================================
    process(clk, reset)
    begin
        if reset = '1' then
            bit_ptr <= DATA_WIDTH - 1;
            tick_counter <= 0;
            current_lvl <= '0';
            nrz_signal <= '0';
        elsif rising_edge(clk) then
            -- Avalia apenas no início de um novo ciclo de bit
            if tick_counter = 0 then
                if data_in(bit_ptr) = '1' then
                    current_lvl <= not current_lvl;
                    nrz_signal <= not current_lvl;
                else
                    nrz_signal <= current_lvl;
                end if;
            else
                nrz_signal <= current_lvl;
            end if;

            -- Temporização e ponteiro
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

    -- ==========================================
    -- 2. Divisor de Clock para VGA (100 MHz -> 25 MHz)
    -- ==========================================
    process(clk, reset)
    begin
        if reset = '1' then
            clk_div <= 0;
            clk_25MHz <= '0';
        elsif rising_edge(clk) then
            if clk_div = 1 then
                clk_25MHz <= not clk_25MHz;
                clk_div <= 0;
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;

    -- ==========================================
    -- 3. Varredura e Sincronização VGA (Clock de 25 MHz)
    -- ==========================================
    process(clk_25MHz, reset)
    begin
        if reset = '1' then
            h_count <= 0;
            v_count <= 0;
        elsif rising_edge(clk_25MHz) then
            -- Contagem horizontal (0 a 799)
            if h_count = 799 then
                h_count <= 0;
                -- Contagem vertical (0 a 524)
                if v_count = 524 then
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
                end if;
            else
                h_count <= h_count + 1;
            end if;
        end if;
    end process;

    -- Geração dos pulsos de sincronismo para 640x480 @ 60Hz
    Hsync <= '0' when (h_count >= 656 and h_count < 752) else '1';
    Vsync <= '0' when (v_count >= 490 and v_count < 492) else '1';
    
    -- Indica quando o feixe está na área visível da tela
    video_on <= '1' when (h_count < 640 and v_count < 480) else '0';

    -- ==========================================
    -- 4. Geração de Imagem (Preto = 0, Branco = 1)
    -- ==========================================
    process(video_on, nrz_signal)
    begin
        if video_on = '1' then
            if nrz_signal = '1' then
                -- Nível Alto: Tela Branca
                vgaRed   <= "1111";
                vgaGreen <= "1111";
                vgaBlue  <= "1111";
            else
                -- Nível Baixo: Tela Preta
                vgaRed   <= "0000";
                vgaGreen <= "0000";
                vgaBlue  <= "0000";
            end if;
        else
            -- Durante os períodos de sincronização e blanking, os sinais RGB DEVEM ser 0
            vgaRed   <= "0000";
            vgaGreen <= "0000";
            vgaBlue  <= "0000";
        end if;
    end process;

end Behavioral;