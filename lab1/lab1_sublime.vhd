entity THERMOSTAT is
	port (
		CURRENT_TEMP	: in  bit_vector (7 downto 0);
		DESIRED_TEMP	: in  bit_vector (7 downto 0);
		DISPLAY_SELECT	: in  bit;
		TEMP_DISPLAY	: out bit_vector (7 downto 0)
	);
	
end entity THERMOSTAT;

architecture THERMOSTAT_ARCH of THERMOSTAT is
begin
	process (CURRENT_TEMP, DESIRED_TEMP, DISPLAY_SELECT)
	begin
		if DISPLAY_SELECT = '1' then
			TEMP_DISPLAY <= CURRENT_TEMP;
		else
			TEMP_DISPLAY <= DESIRED_TEMP;
		end if;

	end process;
	
end architecture THERMOSTAT_ARCH;