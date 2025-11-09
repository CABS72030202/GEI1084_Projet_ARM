----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 10/05/2025 03:02:25 PM
-- Design Name: 
-- Module Name: register_file - Synth
-- Project Name: project_lab2
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    16-register file of 32 bits each for ARM processor implementation.
--    Registers are modeled as RAM with asynchronous reads and synchronous writes.
--    Supports two simultaneous reads and one write per clock cycle.
-- 
-- Dependencies: IEEE STD_LOGIC_1164, STD_LOGIC_UNSIGNED, NUMERIC_STD
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Added initialization and comments
-- Revision 1.00 - Added asynchronous RESET
-- Additional Comments:
--    - All registers initialized to zero on startup
--    - R15 input is currently unused as per exercise requirements
--    - Write operations are synchronized to rising clock edge
--    - Read operations are asynchronous
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    generic(
        N: integer := 4;    -- Address bus width (16 registers = 2^4)
        M: integer := 32    -- Data bus width (32 bits per register)
    );
    Port(
        clk : in STD_LOGIC;                         -- System clock
        rst : in STD_LOGIC;                         -- Asynchronous RESET (active LOW)
        we3 : in STD_LOGIC;                         -- Write enable signal (RegWrite)
        a1  : in STD_LOGIC_VECTOR(N-1 downto 0);    -- Read address for register Rn
        a2  : in STD_LOGIC_VECTOR(N-1 downto 0);    -- Read address for register Rm
        a3  : in STD_LOGIC_VECTOR(N-1 downto 0);    -- Write address for register Rd
        wd3 : in STD_LOGIC_VECTOR(M-1 downto 0);    -- Data to be written to register Rd
        r15 : in STD_LOGIC_VECTOR(M-1 downto 0);    -- R15 input
        rd1 : out STD_LOGIC_VECTOR(M-1 downto 0);   -- Read data output from register Rn
        rd2 : out STD_LOGIC_VECTOR(M-1 downto 0)    -- Read data output from register Rm
    );
end register_file;

architecture synth of register_file is
    type mem_array is array ((2**N-1) downto 0) of STD_LOGIC_VECTOR(M-1 downto 0);
    signal mem: mem_array := (others => (others => '0'));   -- Initialize to 0
begin
    process(clk, rst) begin
        if rst = '0' then
            for i in mem'range loop
                mem(i) <= (others => '0');
            end loop;
            
        elsif rising_edge(clk) then
            -- Check write enable before writing to register Rd
            if we3 = '1' then 
                -- Write data to register at address a3 (Rd)
                mem(TO_INTEGER(unsigned(a3))) <= wd3; 
            end if;
        end if;
    end process;

    -- Asynchronous read
    rd1 <= mem(TO_INTEGER(unsigned(a1)));
    rd2 <= mem(TO_INTEGER(unsigned(a2)));
    
    -- Note: R15 is currently unused as per exercise requirements

end synth;
