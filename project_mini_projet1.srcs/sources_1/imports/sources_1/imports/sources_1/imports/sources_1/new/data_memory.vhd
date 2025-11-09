----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 10/05/2025 05:39:32 PM
-- Design Name: 
-- Module Name: data_memory - synth
-- Project Name: project_lab2
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    64 x 32-bit data memory block with asynchronous read and synchronous write
--    Only uses address bits A(5:0) to access 64 memory locations
-- 
-- Dependencies: IEEE STD_LOGIC_1164, NUMERIC_STD
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Fixed memory size and port directions
-- Revision 1.00 - Added asynchronous RESET
-- Additional Comments:
--    Memory size: 64 locations of 32 bits each
--    Read: Asynchronous (continuous)
--    Write: Synchronous (rising clock edge + MemWrite enabled)
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    generic (
        M: integer := 32
    );
    Port ( 
        clk : in STD_LOGIC;                        -- System clock
        rst : in STD_LOGIC;                        -- Asynchronous RESET (active LOW)
        we  : in STD_LOGIC;                        -- Memory write enable (MemWrite)
        a   : in STD_LOGIC_VECTOR(M-1 downto 0);   -- Address input
        wd  : in STD_LOGIC_VECTOR(M-1 downto 0);   -- Write data input
        rd  : out STD_LOGIC_VECTOR(M-1 downto 0)   -- Read data output
    );
end data_memory;

architecture synth of data_memory is
    type mem_array is array (2*M-1 downto 0) of STD_LOGIC_VECTOR(M-1 downto 0);
    signal mem: mem_array := (others => (others => '0'));   -- Initialize to 0
    
begin
    process(clk, rst) 
    begin
        if rst = '0' then
            for i in mem'range loop
                mem(i) <= (others => '0');
            end loop;

        elsif rising_edge(clk) then
            if we = '1' then 
                -- Write data to memory at address a(5 downto 0)
                mem(TO_INTEGER(unsigned(a(5 downto 0)))) <= wd; 
            end if;
        end if;
    end process;

    -- Asynchronous read
    rd <= mem(TO_INTEGER(unsigned(a(5 downto 0))));
    
end synth;