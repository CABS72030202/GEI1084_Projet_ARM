----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/03/2025 12:00:48 AM
-- Design Name: Control Unit
-- Module Name: ctrl_unit - struct
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This module implements the complete control unit for the ARM processor,
--    combining the instruction decoder with conditional execution logic.
--    It generates all control signals needed for datapath operation while
--    handling conditional instruction execution based on processor flags.
-- 
-- Dependencies: 
--    ctrl_unit_decoder.vhd, cond_logic.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Complete control unit integration completed
-- Additional Comments:
--    
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl_unit is
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
end ctrl_unit;

architecture struct of ctrl_unit is

    -- Component declarations
    component ctrl_unit_decoder is
        Port ( 
               Op           : in STD_LOGIC_VECTOR (1 downto 0);
               Funct        : in STD_LOGIC_VECTOR (5 downto 0);
               Rd           : in STD_LOGIC_VECTOR (3 downto 0);
               FlagW        : out STD_LOGIC_VECTOR (1 downto 0);
               PCS          : out STD_LOGIC;
               RegW         : out STD_LOGIC;
               MemW         : out STD_LOGIC;
               MemtoReg     : out STD_LOGIC;
               ALUSrc       : out STD_LOGIC;
               ImmSrc       : out STD_LOGIC_VECTOR (1 downto 0);
               RegSrc       : out STD_LOGIC_VECTOR (1 downto 0);
               ALUControl   : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    
    component cond_logic is
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
    end component;
    
    -- Internal signals
    signal FlagW : STD_LOGIC_vECTOR(1 downto 0);
    signal PCS, RegW, MemW : STD_LOGIC;
begin

    -- Instantiate components
    DECODER:    ctrl_unit_decoder
        port map (
            Op          => Op,
            Funct       => Funct,
            Rd          => Rd,
            FlagW       => FlagW,
            PCS         => PCS,
            RegW        => RegW,
            MemW        => MemW,
            MemtoReg    => MemtoReg,
            ALUSrc      => ALUSrc,
            ImmSrc      => ImmSrc,
            RegSrc      => RegSrc,
            ALUControl  => ALUControl
        );
        
    C_LOGIC:    cond_logic
        port map (
            clk         => clk,
            rst         => rst,
            PCS         => PCS,
            RegW        => RegW,
            MemW        => MemW,
            FlagW       => FlagW,
            Cond        => Cond,
            ALUFlags    => ALUFlags,
            PCSrc       => PCSrc,
            RegWrite    => RegWrite,
            MemWrite    => MemWrite
        );

end struct;
