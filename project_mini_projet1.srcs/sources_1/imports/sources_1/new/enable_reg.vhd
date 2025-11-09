----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/02/2025 10:13:39 PM
-- Design Name: Enabled Register with Asynchronous Reset
-- Module Name: enable_reg - synth
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements a parameterizable register with enable and asynchronous reset.
--    The register stores the input value on the rising edge of the clock when enable is active.
--    Asynchronous reset clears the output to all zeros when active.
-- 
-- Dependencies: 
--    None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Register implementation completed
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enable_reg is
    generic (M : integer := 32);
    Port ( 
           clk      : in STD_LOGIC;                         -- System clock signal
           ena      : in STD_LOGIC;                         -- Value selection signal
           rst      : in STD_LOGIC;                         -- Asynchronous RESET (active LOW)
           input    : in STD_LOGIC_VECTOR (M-1 downto 0);   -- Value to be stored
           output   : out STD_LOGIC_VECTOR (M-1 downto 0)   -- Stored value
    );
end enable_reg;

architecture synth of enable_reg is

begin
    process(clk, rst)
    begin
        if rst = '0' then
            -- Asynchronous reset (active low) - clear output to all zeros
            output <= (others => '0');
        elsif rising_edge(clk) then
            -- On rising clock edge, store input if enable is active
            if ena = '1' then
                output <= input;
            end if;
        end if;
    end process;

end synth;