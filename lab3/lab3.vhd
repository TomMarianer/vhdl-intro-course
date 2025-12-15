entity THERMOSTAT is
    port (
        CURRENT_TEMP    : in  bit_vector (6 downto 0);
        DESIRED_TEMP    : in  bit_vector (6 downto 0);
        DISPLAY_SELECT  : in  bit;
        COOL            : in  bit;
        HEAT            : in  bit;
        CLK             : in  bit;
        RESET           : in  bit;
        TEMP_DISPLAY    : out bit_vector (6 downto 0);
        AC_ON           : out bit;
        FURNACE_ON      : out bit
    );
    
end entity THERMOSTAT;

architecture THERMOSTAT_ARCH of THERMOSTAT is

signal CURRENT_TEMP_REG     : bit_vector (6 downto 0);
signal DESIRED_TEMP_REG     : bit_vector (6 downto 0);
signal DISPLAY_SELECT_REG   : bit;
signal COOL_REG             : bit;
signal HEAT_REG             : bit;
signal TEMP_DISPLAY_INT     : bit_vector (6 downto 0);
signal AC_ON_INT            : bit;
signal FURNACE_ON_INT       : bit;

begin
    DISPLAY: process (CURRENT_TEMP_REG, DESIRED_TEMP_REG, DISPLAY_SELECT_REG)
    begin
        if DISPLAY_SELECT_REG = '1' then
            TEMP_DISPLAY_INT <= CURRENT_TEMP_REG;
        else
            TEMP_DISPLAY_INT <= DESIRED_TEMP_REG;
        end if;

    end process;

    AC: process (COOL_REG, CURRENT_TEMP_REG, DESIRED_TEMP_REG)
    begin
        AC_ON_INT <= '0';
        if (COOL_REG = '1') and (DESIRED_TEMP_REG < CURRENT_TEMP_REG) then
            AC_ON_INT <= '1';
        end if;

    end process;

    FURNACE: process (HEAT_REG, CURRENT_TEMP_REG, DESIRED_TEMP_REG)
    begin
        FURNACE_ON_INT <= '0';
        if (HEAT_REG = '1') and (DESIRED_TEMP_REG > CURRENT_TEMP_REG) then
            FURNACE_ON_INT <= '1';
        end if;

    end process;

    REGISTER_INPUTS: process(CLK, RESET)
    begin
        if RESET = '1' then
            CURRENT_TEMP_REG    <= (others => '0');
            DESIRED_TEMP_REG    <= (others => '0');
            DISPLAY_SELECT_REG  <= '0';
            COOL_REG            <= '0';
            HEAT_REG            <= '0';
        elsif rising_edge(CLK) then
            CURRENT_TEMP_REG    <= CURRENT_TEMP;
            DESIRED_TEMP_REG    <= DESIRED_TEMP;
            DISPLAY_SELECT_REG  <= DISPLAY_SELECT;
            COOL_REG            <= COOL;
            HEAT_REG            <= HEAT;
        end if;
    end process;

end architecture THERMOSTAT_ARCH;