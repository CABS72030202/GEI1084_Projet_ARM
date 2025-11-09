----------------------------------------------------------------------------------
-- Company: Universite du Quebec a Trois-Rivieres - GEI1084-00
-- Engineer: Sebastien Cabana
-- 
-- Create Date: 11/03/2025 11:52:54 AM
-- Design Name: ARM Processor Testbench
-- Module Name: tb_arm_proc - tb
-- Project Name: project_lab4
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--    This testbench module verifies the functionality of the complete ARM processor.
--    It applies test vectors from an external file and compares the processor's
--    outputs against expected results. The testbench monitors ALUResult and
--    WriteData outputs and reports overall test success or failure.
-- 
-- Dependencies: arm_proc.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Testbench implementation completed
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity tb_arm_proc is
    Port (test_passed : out STD_LOGIC);
end tb_arm_proc;

architecture tb of tb_arm_proc is
    constant CLK_PERIOD : time := 10 ns;
    constant M : integer := 32;
    constant N : integer := 4;
    
    -- Component Declaration for the Unit Under Test (UUT)
    component arm_proc is
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
    end component;
    
    -- Signals
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal ALUResult : STD_LOGIC_VECTOR(M-1 downto 0);
    signal WriteData : STD_LOGIC_VECTOR(M-1 downto 0);
    
    -- Expected output signals
    signal EXP_ALUResult : STD_LOGIC_VECTOR(M-1 downto 0);
    signal EXP_WriteData : STD_LOGIC_VECTOR(M-1 downto 0);
    
    -- Test control
    signal test_pass    : STD_LOGIC := '1'; 
    file stim_file      : text open read_mode is "ExpectedData.txt"; 
    signal sim_done     : STD_LOGIC := '0';

begin
        
    -- Instantiate the Unit Under Test (UUT)
    UUT:    arm_proc
    generic map (M => M, N => N)
    port map (
        clk         => clk, 
        rst         => rst,
        ALUResult   => ALUResult,
        WriteData   => WriteData
    );
    
    -- Connect test pass signal to output
    test_passed <= test_pass;
    
    -- System clock process
    clock_gen_proc: process
    begin
        -- Reset on startup
        rst <= '0';
        wait for 2 ns;        -- Wait for initial stabilization
        rst <= '1';
            
        while sim_done = '0' loop
            clk <= '0'; wait for CLK_PERIOD / 2;
            clk <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;
        
    -- Testbench process
    stim_proc:  process
        variable file_line      : line;
        variable vector1        : STD_LOGIC_VECTOR(M-1 downto 0);
        variable vector2        : STD_LOGIC_VECTOR(M-1 downto 0);
        variable dummy          : character;
        variable vector_num     : integer := 0;
    begin  
        while not endfile(stim_file) loop
        
            -- Read current line
            readline(stim_file, file_line);
            
            -- Split line into vectors
            read(file_line, vector1);
            read(file_line, dummy);
            read(file_line, vector2);
            
            -- Update values on rising edge
            EXP_ALUResult   <= vector1;
            EXP_WriteData   <= vector2;
            
            -- Test control
            wait for 2 ns;
            if ALUResult /= EXP_ALUResult or WriteData /= EXP_WriteData then
                test_pass <= '0';
            else
                test_pass <= '1';
            end if;
            
            -- Wait for next clock cycle
            wait until rising_edge(clk);
        end loop;
        
        -- End simulation
        sim_done <= '1';
        wait;
    end process;
    
    test_flag: process(test_pass)
    begin
        test_passed <= test_pass;
    end process;
end tb;
