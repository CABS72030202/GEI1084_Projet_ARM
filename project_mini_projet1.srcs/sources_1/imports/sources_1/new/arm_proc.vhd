----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/03/2025 11:11:02 AM
-- Design Name: Complete ARM Processor
-- Module Name: arm_proc - struct
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the complete ARM processor by integrating all major
--    components: control unit, instruction fetch unit, and register bank 
--    datapath. It forms a fully functional ARM processor core capable of
--    executing ARMv4 instruction set subsets including data processing,
--    memory access, and branch operations.
-- 
-- Dependencies: 
--      ctrl_unit.vhd, bank_instr.vhd, bank_register.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Complete processor integration completed
-- Additional Comments:
--    This is the top-level module that integrates all processor components:
--    - Instruction Fetch Stage: Fetches instructions and manages program flow
--    - Control Unit: Decodes instructions and generates control signals
--    - Register Bank Datapath: Executes instructions and manages data
--       
--    This implementation follows the ARM processor architecture described in:
--    Harris & Harris, "Digital Design and Computer Architecture, ARM Edition"
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity arm_proc is
    generic (
        M : integer := 32;
        N : integer := 4
    );
    Port ( 
        clk         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        ALUResult   : out STD_LOGIC_VECTOR (M-1 downto 0);
        WriteData   : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end arm_proc;

architecture struct of arm_proc is

    -- Component declarations
    component ctrl_unit is
        Port ( 
            clk          : in STD_LOGIC;
            rst          : in STD_LOGIC;
            Cond         : in STD_LOGIC_VECTOR (3 downto 0);
            ALUFlags     : in STD_LOGIC_VECTOR (3 downto 0);
            Op           : in STD_LOGIC_VECTOR (1 downto 0);
            Funct        : in STD_LOGIC_VECTOR (5 downto 0);
            Rd           : in STD_LOGIC_VECTOR (3 downto 0);
            PCSrc        : out STD_LOGIC;
            RegWrite     : out STD_LOGIC;
            MemWrite     : out STD_LOGIC;
            MemtoReg     : out STD_LOGIC;
            ALUSrc       : out STD_LOGIC;
            ImmSrc       : out STD_LOGIC_VECTOR (1 downto 0);
            RegSrc       : out STD_LOGIC_VECTOR (1 downto 0);
            ALUControl   : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    
    component bank_instr is
        generic (M : integer := 32);
        Port ( 
            clk      : in STD_LOGIC;
            rst      : in STD_LOGIC;
            PCSrc    : in STD_LOGIC;
            Result   : in STD_LOGIC_VECTOR (M-1 downto 0);
            Instr    : out STD_LOGIC_VECTOR (M-1 downto 0);
            PCPlus8  : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
    
    component bank_register is
        generic ( 
            M : integer := 32;
            N : integer := 4
        );
        Port (
            clk          : in STD_LOGIC;
            rst          : in STD_LOGIC;                        -- Asynchronous RESET (active LOW)
            -- Control Signals (blue signals from diagram)
            RegWrite     : in STD_LOGIC;
            ImmSrc       : in STD_LOGIC_VECTOR(1 downto 0);
            ALUSrc       : in STD_LOGIC;
            ALUControl   : in STD_LOGIC_VECTOR(1 downto 0);
            MemWrite     : in STD_LOGIC;
            MemtoReg     : in STD_LOGIC;
            RegSrc       : in STD_LOGIC_VECTOR(1 downto 0);
            R15          : in STD_LOGIC_VECTOR(M-1 downto 0);
            -- Instruction Input
            Instr        : in STD_LOGIC_VECTOR(M-1 downto 0);
            -- Outputs
            ALUFlags     : out STD_LOGIC_VECTOR(N-1 downto 0);  -- 4 flags: N, Z, C, V
            Result       : out STD_LOGIC_VECTOR(M-1 downto 0);  -- Mux output after memory
            ALUResult    : out STD_LOGIC_VECTOR(M-1 downto 0);
            WriteData    : out STD_LOGIC_VECTOR(M-1 downto 0)
            );
    end component;
    
    -- Internal signals
    signal Instr, Result, PCPlus8 : STD_LOGIC_VECTOR(M-1 downto 0);
    signal ALUFlags : STD_LOGIC_VECTOR(N-1 downto 0);
    signal ImmSrc, RegSrc, ALUControl : STD_LOGIC_VECTOR(1 downto 0);
    signal PCSrc, RegWrite, MemWrite, MemtoReg, ALUSrc : STD_LOGIC;

begin

    -- Instantiate components
    CONTROL_UNIT:       ctrl_unit
        port map (
            clk         => clk,
            rst         => rst,
            Cond        => Instr(31 downto 28),
            ALUFlags    => ALUFlags,
            Op          => Instr(27 downto 26),
            Funct       => Instr(25 downto 20),
            Rd          => Instr(15 downto 12),
            PCSrc       => PCSrc,
            RegWrite    => RegWrite,
            MemWrite    => MemWrite,
            MemtoReg    => MemtoReg,
            ALUSrc      => ALUSrc,
            ImmSrc      => ImmSrc,
            RegSrc      => RegSrc,
            ALUControl  => ALUControl
        );
        
    BANK_INSTRUCTIONS:  bank_instr
        generic map (M => M)
        port map (
            clk         => clk,
            rst         => rst,
            PCSrc       => PCSrc,
            Result      => Result,
            Instr       => Instr,
            PCPlus8     => PCPlus8
        );
        
    BANK_REG:           bank_register
        generic map (M => M, N => N)
        port map (
            clk         => clk,
            rst         => rst,
            RegWrite    => RegWrite,
            ImmSrc      => ImmSrc,
            ALUSrc      => ALUSrc,
            ALUControl  => ALUControl,
            MemWrite    => MemWrite,
            MemtoReg    => MemtoReg,
            RegSrc      => RegSrc,
            R15         => PCPlus8,
            Instr       => Instr,
            ALUFlags    => ALUFlags,
            Result      => Result,
            ALUResult   => ALUResult,
            WriteData   => WriteData
        );
end struct;
