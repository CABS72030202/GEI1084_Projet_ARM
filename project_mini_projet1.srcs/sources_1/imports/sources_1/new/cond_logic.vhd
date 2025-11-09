----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/02/2025 11:22:09 PM
-- Design Name: Conditional Logic Unit
-- Module Name: cond_logic - struct
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the conditional execution logic for the ARM processor.
--    It manages flag storage, condition checking, and conditional control signal
--    generation. The module determines whether instructions should be executed
--    based on the current processor state and condition codes, and controls
--    the updating of processor flags.
-- 
-- Dependencies: 
--    enable_reg.vhd, cond_check.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Component interconnections and logic completed
-- Additional Comments:
--    
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cond_logic is
    Port ( 
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           PCS      : in STD_LOGIC;
           RegW     : in STD_LOGIC;
           MemW     : in STD_LOGIC;
           FlagW    : in STD_LOGIC_VECTOR (1 downto 0);
           Cond     : in STD_LOGIC_VECTOR (3 downto 0);
           ALUFlags : in STD_LOGIC_VECTOR (3 downto 0);
           PCSrc    : out STD_LOGIC;
           RegWrite : out STD_LOGIC;
           MemWrite : out STD_LOGIC
    );
end cond_logic;

architecture struct of cond_logic is

    -- Component declarations
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
    
    component cond_check is
        Port ( 
               Flags_NZ : in STD_LOGIC_VECTOR (1 downto 0);
               Flags_CV : in STD_LOGIC_VECTOR (1 downto 0);
               Cond     : in STD_LOGIC_VECTOR (3 downto 0);
               CondEx   : out STD_LOGIC
        );
    end component;
    
    -- Internal signals
    signal FlagWrite, NZ, CV : STD_LOGIC_VECTOR(1 downto 0);
    signal CondEx : STD_LOGIC;

begin
    FlagWrite <= FlagW and CondEx;

    -- Instantiate components
    EN_REG_NZ:  enable_reg
        generic map (M => 2)
        port map (
            clk         => clk,
            ena         => FlagWrite(1),
            rst         => rst,
            input       => ALUFlags(3 downto 2),
            output      => NZ
        );
        
    EN_REG_CV:  enable_reg
        generic map (M => 2)
        port map (
            clk         => clk,
            ena         => FlagWrite(0),
            rst         => rst,
            input       => ALUFlags(1 downto 0),
            output      => CV
        );
    
    CHECK:      cond_check
        port map (
            Flags_NZ    => NZ,
            Flags_CV    => CV,
            Cond        => Cond,
            CondEx      => CondEx
        );
    
    -- Link outputs
    PCSrc       <= CondEx and PCS;
    RegWrite    <= CondEx and RegW;
    MemWrite    <= CondEx and MemW;

end struct;
