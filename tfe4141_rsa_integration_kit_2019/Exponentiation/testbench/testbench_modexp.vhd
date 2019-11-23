----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06.11.2019 10:29:38
-- Design Name:
-- Module Name: testbench_modexp - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- TEXT IO
use STD.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench_modexp is
--  Port ( );
end testbench_modexp;

architecture Behavioral of testbench_modexp is
    component modexp is
        port (
            clock, reset_n: in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            data_ready : out std_logic
          ) ;
    end component;
    -- signals
    signal clock : std_logic := '0';
    signal done : std_logic := '0';
    -- modexp
    signal modexp_reset_n, modexp_data_ready : std_logic;
    signal modexp_e, modexp_n, modexp_p, modexp_m, modexp_p_mon, modexp_data_out : std_logic_vector(255 downto 0);
    -- constants
    constant clock_period : time := 1us;
    -- files
    file file_vectors    : text;
    file file_results    : text;
    file file_error_log  : text;
begin
    mod_exp_test: modexp port map( clock => clock,
                            reset_n => modexp_reset_n,
                            e => modexp_e,
                            n => modexp_n,
                            p => modexp_p,
                            m => modexp_m,
                            p_mon => modexp_p_mon,
                            data_out => modexp_data_out,
                            data_ready => modexp_data_ready);


    clk_gen: process is
        begin
        if done = '0' then
            clock <= '1';
            wait for 6 ns;
            clock <= '0';
            wait for 6 ns;
         else
            wait;
         end if;
        end process;


    modexp_test_process: process
        -- line variables
        variable v_LINE_vector  : line;
        variable v_LINE_result  : line;
        variable v_LINE_error   : line;
        -- read variables
        variable v_ADD_m        : std_logic_vector(255 downto 0);
        variable v_ADD_p        : std_logic_vector(255 downto 0);
        variable v_ADD_p_mon    : std_logic_vector(255 downto 0);
        variable v_ADD_n        : std_logic_vector(255 downto 0);
        variable v_ADD_e        : std_logic_vector(255 downto 0);
        variable v_ADD_fasit    : std_logic_vector(255 downto 0);
        -- log information
        variable log_success        : string(1 to 22)   := "successfull run, run: ";
        variable log_error          : string(1 to 27)   := "error, values differ, run: ";
        variable space              : string(1 to 3)    := "   ";
        variable log_error_expected : string(1 to 10)    := "expected: ";
        variable log_error_got      : string(1 to 11)   := ", but got: ";
        -- counter
        variable run_number :integer := 0;
    begin

        file_open(file_vectors,   "userdefined\testvectors\modexp_testvectors.txt",    read_mode);
        file_open(file_results,   "userdefined\modexp_output_results.txt",   write_mode);
        file_open(file_error_log, "userdefined\modexp_output_error_log.txt", write_mode);
        for i in 0 to 1 loop
            readline(file_vectors,v_LINE_vector);
            read(v_LINE_vector, v_ADD_fasit);
            read(v_LINE_vector, v_ADD_p);
            read(v_LINE_vector, v_ADD_m);
            read(v_LINE_vector, v_ADD_n);
            read(v_LINE_vector, v_ADD_p_mon);
            read(v_LINE_vector, v_ADD_e);

            report "read from files";
            wait for 10ns;
            modexp_p        <= v_ADD_p;
            modexp_m        <= v_ADD_m;
            modexp_n        <= v_ADD_n;
            modexp_p_mon    <= v_ADD_p_mon;
            modexp_e        <= v_ADD_e;

            modexp_reset_n <= '0';
            wait for 10ns;
            modexp_reset_n <= '1';
            wait for 10ns;
            wait on modexp_data_ready;
            if(modexp_data_out = v_add_fasit) then
                write(v_line_result, log_success ,left, 22);
                write(v_line_result, i, right, 5);
                write(v_line_result, space ,left, 3);
                write(v_LINE_result, modexp_data_out, right, 255);
            else
                write(v_line_result, log_error ,left, 27);
                write(v_line_result, i, right, 16);
                write(v_line_result, space ,left, 3);
                write(v_LINE_result, modexp_data_out, right, 255);

                write(v_line_error, log_error, left, 27);
                write(v_line_error, i, right, 5);
                write(v_line_error, space ,left, 3);
                write(v_line_error, log_error_expected, left, 10);
                write(v_line_error, v_add_fasit, right, 255);
                write(v_line_error, log_error_got, right, 11);
                write(v_LINE_error, modexp_data_out, right, 255);

                writeline(file_error_log, v_line_error);
            end if;

            writeline(file_results, v_line_result);

        end loop;
        file_close(file_vectors);
        file_close(file_results);
        file_close(file_error_log);
        done <= '1';
        wait;
    end process;


end Behavioral;
