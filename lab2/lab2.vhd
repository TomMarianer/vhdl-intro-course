entity THERMOSTAT is
	port (
		CURRENT_TEMP	: in  bit_vector (6 downto 0);
		DESIRED_TEMP	: in  bit_vector (6 downto 0);
		DISPLAY_SELECT	: in  bit;
		COOL			: in  bit;
		HEAT 			: in  bit;
		TEMP_DISPLAY	: out bit_vector (6 downto 0);
		AC_ON			: out bit;
		FURNACE_ON		: out bit
	);
	
end entity THERMOSTAT;

architecture THERMOSTAT_ARCH of THERMOSTAT is
begin
	DISPLAY: process (CURRENT_TEMP, DESIRED_TEMP, DISPLAY_SELECT)
	begin
		if DISPLAY_SELECT = '1' then
			TEMP_DISPLAY <= CURRENT_TEMP;
		else
			TEMP_DISPLAY <= DESIRED_TEMP;
		end if;

	end process;

	AC: process (COOL, CURRENT_TEMP, DESIRED_TEMP)
	begin
		AC_ON <= '0';
		if (COOL = '1') and (DESIRED_TEMP < CURRENT_TEMP) then
			AC_ON <= '1';
		end if;

	end process;

	FURNACE: process (HEAT, CURRENT_TEMP, DESIRED_TEMP)
	begin
		FURNACE_ON <= '0';
		if (HEAT = '1') and (DESIRED_TEMP > CURRENT_TEMP) then
			FURNACE_ON <= '1';
		end if;

	end process;

	
end architecture THERMOSTAT_ARCH;