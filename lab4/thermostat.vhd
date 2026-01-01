library ieee;
use ieee.std_logic_1164.all;

entity THERMOSTAT is
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
    
end entity THERMOSTAT;

architecture THERMOSTAT_ARCH of THERMOSTAT is

type THERMOSTAT_STATE_T is (IDLE, COOL_ON, AC_NOW_READY, AC_DONE, HEAT_ON, FURNACE_NOW_READY, FURNACE_DONE);

signal CURRENT_TEMP_REG     : std_logic_vector (6 downto 0);
signal DESIRED_TEMP_REG     : std_logic_vector (6 downto 0);
signal DISPLAY_SELECT_REG   : std_logic;
signal COOL_REG             : std_logic;
signal AC_READY_REG         : std_logic;
signal HEAT_REG             : std_logic;
signal FURNACE_HOT_REG      : std_logic;
signal TEMP_DISPLAY_INT     : std_logic_vector (6 downto 0);
signal AC_ON_INT            : std_logic;
signal FURNACE_ON_INT       : std_logic;
signal FAN_ON_INT           : std_logic;
signal CURRENT_STATE        : THERMOSTAT_STATE_T;
signal NEXT_STATE           : THERMOSTAT_STATE_T;

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
        elsif CLK'event and CLK = '1' then
            CURRENT_TEMP_REG    <= CURRENT_TEMP;
            DESIRED_TEMP_REG    <= DESIRED_TEMP;
            DISPLAY_SELECT_REG  <= DISPLAY_SELECT;
            COOL_REG            <= COOL;
            HEAT_REG            <= HEAT;
        end if;
    end process;

    REGISTER_OUTPUTS: process(CLK, RESET)
    begin
        if RESET = '1' then
            TEMP_DISPLAY    <= (others => '0');
            AC_ON           <= '0';
            FURNACE_ON      <= '0';
        elsif CLK'event and CLK = '1' then
            TEMP_DISPLAY    <= TEMP_DISPLAY_INT;
            AC_ON           <= AC_ON_INT;
            FURNACE_ON      <= FURNACE_ON_INT;
        end if;
    end process;

    STATE_FLIP_FLOP: process(CLK, RESET)
    begin
        if RESET = '1' then
            CURRENT_STATE <= IDLE;
        elsif CLK'event and CLK = '1' then
            CURRENT_STATE <= NEXT_STATE;
        end if;
    end process;

    STATE_MACHINE_TRANSITIONS: process (CURRENT_STATE, CURRENT_TEMP_REG, DESIRED_TEMP_REG, COOL_REG, AC_READY_REG, HEAT_REG, FURNACE_HOT_REG)
    begin
        NEXT_STATE <= CURRENT_STATE;
        case CURRENT_STATE is
            when IDLE =>
                if (COOL_REG = '1') and (DESIRED_TEMP_REG < CURRENT_TEMP_REG) then
                    NEXT_STATE <= COOL_ON;
                elsif (HEAT_REG = '1') and (DESIRED_TEMP_REG > CURRENT_TEMP_REG) then
                    NEXT_STATE <= HEAT_ON;
                end if;

            when COOL_ON =>
                if (AC_READY_REG = '1') then
                    NEXT_STATE <= AC_NOW_READY;
                end if;

            when AC_NOW_READY =>
                if (COOL_REG = '0') or (DESIRED_TEMP_REG > CURRENT_TEMP_REG) then
                    NEXT_STATE <= AC_DONE;
                end if;

            when AC_DONE =>
                if (AC_READY_REG = '0') then
                    NEXT_STATE <= IDLE;
                end if;

            when HEAT_ON =>
                if (FURNACE_HOT_REG = '1') then
                    NEXT_STATE <= FURNACE_NOW_READY;
                end if;

            when FURNACE_NOW_READY =>
                if (HEAT_REG = '0') or (DESIRED_TEMP_REG < CURRENT_TEMP_REG) then
                    NEXT_STATE <= FURNACE_DONE;
                end if;

            when FURNACE_DONE =>
                if (FURNACE_HOT_REG ='0') then
                    NEXT_STATE <= IDLE;
                end if;
        end case;
    end process;

end architecture THERMOSTAT_ARCH;