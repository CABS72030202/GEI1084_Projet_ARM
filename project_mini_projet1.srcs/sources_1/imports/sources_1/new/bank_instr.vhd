----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/03/2025 10:39:05 AM
-- Design Name: Instruction Fetch Unit
-- Module Name: bank_instr - struct
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the complete instruction fetch unit for the ARM processor.
--    It manages the program counter, instruction memory interface, and PC increment
--    logic. The unit handles both sequential instruction execution and branch
--    operations by selecting between PC+4 and branch target addresses.
-- 
-- Dependencies: 
--      mux2.vhd, adder.vhd, enable_reg.vhd, instr_memory.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Instruction fetch unit integration completed
-- Additional Comments:
--    
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bank_instr is
    generic (M : integer := 32);
    Port ( 
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           PCSrc    : in STD_LOGIC;
           Result   : in STD_LOGIC_VECTOR (M-1 downto 0);
           Instr    : out STD_LOGIC_VECTOR (M-1 downto 0);
           PCPlus8  : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end bank_instr;

architecture struct of bank_instr is

    -- Component declarations
    component mux2 is
        generic (N : integer := 32);
        Port ( 
            d0,d1 : in STD_LOGIC_VECTOR(N-1 downto 0);  -- N-bit input vectors
            s     : in STD_LOGIC;                       -- Select line
            y     : out STD_LOGIC_VECTOR(N-1 downto 0)  -- N-bit output vector
        );
    end component;

    component adder is
        generic (N : integer := 32);
        Port ( 
            a,b   : in STD_LOGIC_VECTOR(N-1 downto 0);
            cin   : in STD_LOGIC;
            s     : out STD_LOGIC_VECTOR(N-1 downto 0);
            cout  : out STD_LOGIC
        );
    end component;

    component enable_reg is
        generic (M : integer := 32);
        Port ( 
            clk      : in STD_LOGIC;                         -- System clock signal
            ena      : in STD_LOGIC;                         -- Value selection signal
            rst      : in STD_LOGIC;                         -- Asynchronous RESET (active LOW)
            input    : in STD_LOGIC_VECTOR (M-1 downto 0);   -- Value to be stored
            output   : out STD_LOGIC_VECTOR (M-1 downto 0)   -- Stored value
        );
    end component;

    component instr_memory is
        generic(M : integer := 32);
        Port ( 
            A   : in STD_LOGIC_VECTOR (M-1 downto 0);
            Rd  : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
    
    -- Internal signals
    signal PCp, PCPlus4, PC : STD_LOGIC_VECTOR(M-1 downto 0);
    signal cout : STD_LOGIC;
    
begin

    -- Instantiate components
    MUX_1:      mux2
        generic map (N => M)
        port map (
            d0      => PCPlus4,
            d1      => Result,
            s       => PCSrc,
            y       => PCp
        );
        
    ADDER_PC4:  adder
        generic map (N => M)
        port map (
            a       => PC,
            b       => STD_LOGIC_VECTOR(TO_UNSIGNED(4, M)),
            cin     => '0',         -- Ignore cin
            s       => PCPlus4,
            cout    => cout         -- Use buffer signal to ignore cout
        );
        
    ADDER_PC8:  adder
        generic map (N => M)
        port map (
            a       => PCPlus4,
            b       => STD_LOGIC_VECTOR(TO_UNSIGNED(4, M)),
            cin     => '0',         -- Ignore cin
            s       => PCPlus8,
            cout    => cout         -- Use buffer signal to ignore cout
        );
    
    CLK_REG:    enable_reg
        generic map (M => M)
        port map (
            clk     => clk,
            ena     => '1',         -- Always active
            rst     => rst,
            input   => PCp,
            output  => PC
        );
    
    INSTR_MEM:  instr_memory
        generic map (M => M)
        port map (
            A       => PC,
            Rd      => Instr
        );

end struct;
