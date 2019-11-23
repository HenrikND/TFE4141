----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06.11.2019 10:30:48
-- Design Name:
-- Module Name: testbench_monpro - Behavioral
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

entity testbench_monpro is
--  Port ( );
end testbench_monpro;

architecture Behavioral of testbench_monpro is
    component monpro is
        port(
          clock, reset_n : in std_logic;
          a, b, n : in std_logic_vector(255 downto 0);
          result : out std_logic_vector(255 downto 0);
          done : out std_logic;
          begin_monpro : in std_logic
        );
    end component;

    -- monpro
    signal monpro_reset_n, monpro_data_ready, monpro_begin_monpro : std_logic;
    signal monpro_a, monpro_n, monpro_b,monpro_data_out: std_logic_vector(255 downto 0);
    -- constants
    constant clock_period : time := 1us;
    -- files
    file file_vectors    : text;
    file file_results    : text;
    file file_error_log  : text;
    -- signals
    signal clock : std_logic := '0';
    signal pro_done : std_logic := '0';

begin

    mon_pro_test: monpro port map( clock => clock,
                            reset_n => monpro_reset_n,
                            a => monpro_a,
                            n => monpro_n,
                            b => monpro_b,
                            result => monpro_data_out,
                            done => monpro_data_ready,
                            begin_monpro => monpro_begin_monpro);

    clk_gen: process is
        begin
            if pro_done = '0' then
                clock <= '1';
                wait for 6 ns;
                clock <= '0';
                wait for 6 ns;
            else
                wait;
            end if;
        end process;



    monpro_pro: process
        variable v_LINE_vector  : line;
        variable v_LINE_result  : line;
        variable v_LINE_error   : line;
        -- read variables
        variable v_ADD_fasit    : std_logic_vector(255 downto 0);
        variable v_ADD_a        : std_logic_vector(255 downto 0);
        variable v_ADD_b        : std_logic_vector(255 downto 0);
        variable v_ADD_n        : std_logic_vector(255 downto 0);
        -- log information
        variable log_success        : string(1 to 22)   := "successfull run, run: ";
        variable log_error          : string(1 to 27)   := "error, values differ, run: ";
        variable space              : string(1 to 3)    := "   ";
        variable log_error_expected : string(1 to 10)    := "expected: ";
        variable log_error_got      : string(1 to 11)   := ", but got: ";
        -- counter
        variable run_number :integer := 0;
    begin
        file_open(file_vectors,   "userdefined\testvectors\monpro_testvectors.txt",    read_mode);
        file_open(file_results,   "userdefined\monpro_output_results.txt",   write_mode);
        file_open(file_error_log, "userdefined\monpro_output_error_log.txt", write_mode);

        for i in 0 to 99 loop
            wait until rising_edge(clock);
            wait until rising_edge(clock);
            monpro_reset_n <= '0';
            wait for 10ns;
            monpro_reset_n <= '1';
            monpro_begin_monpro <= '1';

            readline(file_vectors,v_LINE_vector);
            read(v_LINE_vector, v_ADD_fasit);
            read(v_LINE_vector, v_ADD_a);
            read(v_LINE_vector, v_ADD_b);
            read(v_LINE_vector, v_ADD_n);

            monpro_a <= v_add_a;
            monpro_b <= v_add_b;
            monpro_n <= v_add_n;

            wait until rising_edge(clock);
            wait until rising_edge(clock);
            monpro_begin_monpro <= '0';

            wait on monpro_data_ready;
            wait until rising_edge(clock);
            wait until rising_edge(clock);
            
            if(monpro_data_out = v_add_fasit) then
                write(v_line_result, log_success ,left, 22);
                write(v_line_result, i, right, 5);
                write(v_line_result, space ,left, 3);
                write(v_LINE_result, monpro_data_out, right, 255);
            else
                write(v_line_result, log_error ,left, 27);
                write(v_line_result, i, right, 16);
                write(v_line_result, space ,left, 3);
                write(v_LINE_result, monpro_data_out, right, 255);

                write(v_line_error, log_error, left, 27);
                write(v_line_error, i, right, 5);
                write(v_line_error, space ,left, 3);
                write(v_line_error, log_error_expected, left, 10);
                write(v_line_error, v_add_fasit, right, 255);
                write(v_line_error, log_error_got, right, 11);
                write(v_LINE_error, monpro_data_out, right, 255);

                writeline(file_error_log, v_line_error);
            end if;
            writeline(file_results, v_line_result);
        end loop;
        file_close(file_vectors);
        file_close(file_results);
        file_close(file_error_log);
        pro_done <= '1';
        wait;
    end process;

end Behavioral;
