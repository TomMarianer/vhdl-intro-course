library ieee;
use ieee.std_logic_1164.all;

entity T_THERMOSTAT is
end entity T_THERMOSTAT;

architecture T_THERMOSTAT_ARCH of T_THERMOSTAT is
component THERMOSTAT is
    port (
        CLK             : in  std_logic;
        RESET           : in  std_logic;
        CURRENT_TEMP    : in  std_logic_vector (6 downto 0);
        DESIRED_TEMP    : in  std_logic_vector (6 downto 0);
        DISPLAY_SELECT  : in  std_logic;
        COOL            : in  std_logic;
        AC_READY        : in  std_logic;
        HEAT            : in  std_logic;
        FURNACE_HOT     : in  std_logic;
        TEMP_DISPLAY    : out std_logic_vector (6 downto 0);
        AC_ON           : out std_logic;
        FURNACE_ON      : out std_logic;
        FAN_ON          : out std_logic
    );
    
end component THERMOSTAT;

signal T_CLK            : std_logic := '0';
signal T_RESET          : std_logic := '0';
signal T_CURRENT_TEMP   : std_logic_vector (6 downto 0);
signal T_DESIRED_TEMP   : std_logic_vector (6 downto 0);
signal T_DISPLAY_SELECT : std_logic;
signal T_COOL           : std_logic;
signal T_AC_READY       : std_logic;
signal T_HEAT           : std_logic;
signal T_FURNACE_HOT    : std_logic;
signal T_TEMP_DISPLAY   : std_logic_vector (6 downto 0);
signal T_AC_ON          : std_logic;
signal T_FURNACE_ON     : std_logic;
signal T_FAN_ON         : std_logic;

begin
    T_CLK   <= not T_CLK after 5 ns;
    T_RESET <= '1', '0' after 10 ns;

    UUT: THERMOSTAT
        port map (
            CLK => T_CLK,
            RESET => T_RESET,
            CURRENT_TEMP => T_CURRENT_TEMP,
            DESIRED_TEMP => T_DESIRED_TEMP,
            DISPLAY_SELECT => T_DISPLAY_SELECT,
            COOL => T_COOL,
            AC_READY => T_AC_READY,
            HEAT => T_HEAT,
            FURNACE_HOT => T_FURNACE_HOT,
            TEMP_DISPLAY => T_TEMP_DISPLAY,
            AC_ON => T_AC_ON,
            FURNACE_ON => T_FURNACE_ON,
            FAN_ON => T_FAN_ON
        );

    process
    begin
        -- Test cooling side of state machine
        T_CURRENT_TEMP      <= "1110000";
        T_DESIRED_TEMP      <= "0001111";
        T_DISPLAY_SELECT    <= '0';
        T_COOL              <= '0';
        T_AC_READY          <= '0';
        T_HEAT              <= '0';
        T_FURNACE_HOT       <= '0';
        wait for 50 ns;
        T_COOL              <= '1';
        wait for 50 ns;
        T_AC_READY          <= '1';
        wait for 50 ns;
        T_CURRENT_TEMP      <= "0001110";
        wait for 50 ns;
        T_AC_READY          <= '0';
        wait for 50 ns;
        T_CURRENT_TEMP      <= "1110000";
        T_COOL              <= '0';
        wait for 50 ns;
        T_COOL              <= '1';
        wait for 50 ns;
        T_AC_READY          <= '1';
        wait for 50 ns;
        T_COOL              <= '0';
        wait for 50 ns;
        T_AC_READY          <= '0';
        wait for 50 ns;

        -- Test heating side of state machine
        T_HEAT              <= '1';
        wait for 50 ns;
        T_CURRENT_TEMP      <= "0101010";
        T_DESIRED_TEMP      <= "1010101";
        wait for 50 ns;
        T_FURNACE_ON        <= '1';
        wait for 50 ns;
        T_CURRENT_TEMP      <= "1010111";
        wait for 50 ns;
        T_FURNACE_ON        <= '0';
        wait for 50 ns;
        T_CURRENT_TEMP      <= "0101010";
        T_HEAT              <= '0';
        wait for 50 ns;
        T_HEAT              <= '1';
        wait for 50 ns;
        T_FURNACE_ON        <= '1';
        wait for 50 ns;
        T_HEAT              <= '0';
        wait for 50 ns;
        T_FURNACE_ON        <= '1';
        wait;
    end process;
    
end architecture T_THERMOSTAT_ARCH;