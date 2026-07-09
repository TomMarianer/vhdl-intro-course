library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

signal T_CLK            : std_logic := '1';
signal T_RESET          : std_logic := '1';
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

constant PERIOD                     : time := 10 ns;
constant RESET_TIME                 : time := 10 ns;
constant WAIT_BETWEEN_ACTIONS_BASE  : time := 50 ns;
constant PROPAGATION_DELAY          : time := 2 * PERIOD;
constant PROPAGATION_BUFFER         : time := 0.1 ns;
constant PROPAGATION_WAIT           : time := PROPAGATION_DELAY + PROPAGATION_BUFFER;


begin
    T_CLK   <= not T_CLK after PERIOD/2;
    T_RESET <= '1', '0' after RESET_TIME;

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
        T_CURRENT_TEMP      <= std_logic_vector(to_signed(30, T_CURRENT_TEMP'length));
        T_DESIRED_TEMP      <= std_logic_vector(to_signed(25, T_DESIRED_TEMP'length));
        T_DISPLAY_SELECT    <= '0';

        wait until T_TEMP_DISPLAY'event and T_TEMP_DISPLAY /= (T_TEMP_DISPLAY'range => '0');
        assert FALSE report "T_TEMP_DISPLAY set to " & integer'image(to_integer(signed(T_TEMP_DISPLAY))) & "C at time " & integer'image(NOW / 1 ns) & "ns" severity note;

        T_DISPLAY_SELECT    <= '1';
        wait until T_TEMP_DISPLAY'event and T_TEMP_DISPLAY /= (T_TEMP_DISPLAY'range => '0');
        assert FALSE report "T_TEMP_DISPLAY set to " & integer'image(to_integer(signed(T_TEMP_DISPLAY))) & "C at time " & integer'image(NOW / 1 ns) & "ns" severity note;

        T_COOL              <= '0';
        T_AC_READY          <= '0';
        T_HEAT              <= '0';
        T_FURNACE_HOT       <= '0';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        
        T_COOL              <= '1';
        wait for PROPAGATION_WAIT;
        assert T_AC_ON = '1'                 report "Wrong output T_AC_ON " & std_logic'image(T_AC_ON) & " should be '1', at time " & integer'image(NOW / 1 ns) & "ns"  severity error;
        assert T_FURNACE_ON = '0'            report "Wrong output T_FURNACE_ON " & std_logic'image(T_FURNACE_ON) & " should be '0'" & integer'image(NOW / 1 ns) & "ns"  severity error;
        assert T_FAN_ON = '0'                report "Wrong output T_FAN_ON " & std_logic'image(T_FAN_ON) & " should be '0'" & integer'image(NOW / 1 ns) & "ns"          severity error;

        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_AC_READY          <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_CURRENT_TEMP      <= "0001110";
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_AC_READY          <= '0';
        wait for 200 ns;
        T_CURRENT_TEMP      <= "1110000";
        T_COOL              <= '0';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_COOL              <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_AC_READY          <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_COOL              <= '0';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_AC_READY          <= '0';
        wait for 200 ns;

        -- Test heating side of state machine
        T_HEAT              <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_CURRENT_TEMP      <= "0101010";
        T_DESIRED_TEMP      <= "1010101";
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_FURNACE_HOT        <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_CURRENT_TEMP      <= "1010111";
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_FURNACE_HOT        <= '0';
        wait for 100 ns;
        T_CURRENT_TEMP      <= "0101010";
        T_HEAT              <= '0';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_HEAT              <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_FURNACE_HOT        <= '1';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_HEAT              <= '0';
        wait for WAIT_BETWEEN_ACTIONS_BASE;
        T_FURNACE_HOT        <= '0';
        wait;
    end process;
    
end architecture T_THERMOSTAT_ARCH;