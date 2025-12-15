entity T_THERMOSTAT is
end entity T_THERMOSTAT;

architecture T_THERMOSTAT_ARCH of T_THERMOSTAT is
component THERMOSTAT is
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
    
end component THERMOSTAT;

signal T_CURRENT_TEMP     : bit_vector (6 downto 0);
signal T_DESIRED_TEMP     : bit_vector (6 downto 0);
signal T_DISPLAY_SELECT   : bit;
signal T_COOL             : bit;
signal T_HEAT             : bit;
signal T_TEMP_DISPLAY     : bit_vector (6 downto 0);
signal T_AC_ON            : bit;
signal T_FURNACE_ON       : bit;
signal T_CLK                : bit := '0';
signal T_RESET              : bit := '0';

begin
    T_CLK   <= not T_CLK after 5 ns;
    T_RESET <= '1', '0' after 10 ns;

    UUT: THERMOSTAT
        port map (
            CURRENT_TEMP    => T_CURRENT_TEMP,
            DESIRED_TEMP    => T_DESIRED_TEMP,
            DISPLAY_SELECT  => T_DISPLAY_SELECT,
            COOL            => T_COOL,
            HEAT            => T_HEAT,
            CLK             => T_CLK,
            RESET           => T_RESET,
            TEMP_DISPLAY    => T_TEMP_DISPLAY,
            AC_ON           => T_AC_ON,
            FURNACE_ON      => T_FURNACE_ON
        );

    process
    begin
        T_CURRENT_TEMP      <= "1110000";
        T_DESIRED_TEMP      <= "0001111";
        T_DISPLAY_SELECT    <= '0';
        T_COOL              <= '0';
        T_HEAT              <= '0';
        wait for 12 ns;
        T_COOL              <= '1';
        wait for 12 ns;
        T_COOL              <= '0';
        T_HEAT              <= '1';
        wait for 12 ns;
        T_CURRENT_TEMP      <= "0101010";
        T_DESIRED_TEMP      <= "1010101";
        T_DISPLAY_SELECT    <= '1';
        wait for 12 ns;
        T_DISPLAY_SELECT    <= '0';
        T_COOL              <= '1';
        T_HEAT              <= '0';
        wait for 12 ns;
        T_CURRENT_TEMP      <= "0000000";
        T_DESIRED_TEMP      <= "0000000";
        T_DISPLAY_SELECT    <= '0';
        T_COOL              <= '0';
        T_HEAT              <= '0';
        wait;
    end process;
    
end architecture T_THERMOSTAT_ARCH;