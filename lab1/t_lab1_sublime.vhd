entity T_THERMOSTAT is
end entity T_THERMOSTAT;

architecture T_THERMOSTAT_ARCH of T_THERMOSTAT is
component THERMOSTAT is
	port (
		CURRENT_TEMP	: in  bit_vector (7 downto 0);
		DESIRED_TEMP	: in  bit_vector (7 downto 0);
		DISPLAY_SELECT	: in  bit;
		TEMP_DISPLAY	: out bit_vector (7 downto 0)
	);
end component THERMOSTAT;

signal T_CURRENT_TEMP, T_DESIRED_TEMP, T_TEMP_DISPLAY	: bit_vector (7 downto 0);
signal T_DISPLAY_SELECT									: bit;

begin
UUT: THERMOSTAT
	port map (
		CURRENT_TEMP	=> T_CURRENT_TEMP,
		DESIRED_TEMP	=> T_DESIRED_TEMP,
		DISPLAY_SELECT	=> T_DISPLAY_SELECT,
		TEMP_DISPLAY	=> T_TEMP_DISPLAY
	);

T_CURRENT_TEMP		<= "11110000", "10101010" after 5 ns, "00001111" after 10 ns, "00000000" after 15 ns;
T_DESIRED_TEMP		<= "00001111", "01010101" after 5 ns, "11110000" after 10 ns, "00000000" after 15 ns;
T_DISPLAY_SELECT	<= '0', '1' after 5 ns, '0' after 10 ns;

end architecture T_THERMOSTAT_ARCH;