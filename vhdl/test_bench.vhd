----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04.11.2019 12:51:23
-- Design Name:
-- Module Name: Testbench - Behavioral
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

entity Testbench is
--  Port ( );

end Testbench;

architecture Behavioral of Testbench is
    component multicore is
       generic  (number_of_cores : integer := 5);
        port (
            clock, reset_n , last_message_in, message_in_ready, message_out_ready: in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            data_ready, last_message_out : out std_logic
          ) ;
    end component ;

    component modexp is
        port (
            clock, reset_n: in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            data_ready : out std_logic
          ) ;
    end component;
    component monprov2 is
      port(
        clock, reset_n : in std_logic;
        a, b, n : in std_logic_vector(255 downto 0);
        result : out std_logic_vector(255 downto 0);
        done : out std_logic;
        begin_monpro : in std_logic
      );
    end component;

    -- signals
   signal clock : std_logic := '0';

   -- modexp
   signal modexp_reset_n, modexp_data_ready : std_logic;
   signal modexp_e, modexp_n, modexp_p, modexp_m, modexp_p_mon, modexp_data_out : std_logic_vector(255 downto 0);

   -- monpro
   signal monpro_reset_n, monpro_data_ready, monpro_begin_monpro : std_logic;
   signal monpro_a, monpro_n, monpro_b,monpro_data_out: std_logic_vector(255 downto 0);

   -- multicore
   signal multicore_reset_n, multicore_data_ready, multicore_last_message_out, multicore_last_message_in,multicore_message_in_ready,multicore_message_out_ready : std_logic;
   signal multicore_e, multicore_n, multicore_p, multicore_m, multicore_p_mon, multicore_data_out : std_logic_vector(255 downto 0);

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

        mon_pro_test: monprov2 port map( clock => clock,
                            reset_n => monpro_reset_n,
                            a => monpro_a,
                            n => monpro_n,
                            b => monpro_b,
                            result => monpro_data_out,
                            done => monpro_data_ready,
                            begin_monpro => monpro_begin_monpro);

        multicore_test: multicore port map( clock => clock,
                            reset_n => multicore_reset_n,
                            e => multicore_e,
                            n => multicore_n,
                            p => multicore_p,
                            m => multicore_m,
                            p_mon => multicore_p_mon,
                            data_out => multicore_data_out,
                            data_ready => multicore_data_ready,
                            last_message_out => multicore_last_message_out,
                            last_message_in => multicore_last_message_in,
                            message_in_ready => multicore_message_in_ready,
                            message_out_ready => multicore_message_out_ready);

	clk_gen: process is
	begin
		clock <= '1';
		wait for 6 ns;
		clock <= '0';
		wait for 6 ns;
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

        file_open(file_vectors,   "C:/Users/hnd00/Desktop/project_1/project_1.srcs/sim_1/new/input_vectors.txt",    read_mode);
        file_open(file_results,   "C:/Users/hnd00/Desktop/project_1/project_1.srcs/sim_1/new/output_results.txt",   write_mode);
        file_open(file_error_log, "C:/Users/hnd00/Desktop/project_1/project_1.srcs/sim_1/new/output_error_log.txt", write_mode);
        for i in 0 to 10 loop
            readline(file_vectors,v_LINE_vector);
            read(v_LINE_vector, v_ADD_fasit);
            read(v_LINE_vector, v_ADD_p);
            read(v_LINE_vector, v_ADD_m);
            read(v_LINE_vector, v_ADD_n);
            read(v_LINE_vector, v_ADD_p_mon);
            read(v_LINE_vector, v_ADD_e);

            report "read from files";
            modexp_p        <= v_ADD_p;
            modexp_m        <= v_ADD_m;
            modexp_n        <= v_ADD_n;
            modexp_p_mon    <= v_ADD_p_mon;
            modexp_e        <= v_ADD_e;

            modexp_reset_n <= '0';
            wait for 10ns;
            modexp_reset_n <= '1';
            wait for 100us;

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
        file_open(file_vectors,   "C:\Users\hnd00\OneDrive\Github\TFE4141\monpro_test_vector.txt",    read_mode);
        file_open(file_results,   "C:\Users\hnd00\OneDrive\Github\TFE4141\monpro_output_results.txt",   write_mode);
        file_open(file_error_log, "C:\Users\hnd00\OneDrive\Github\TFE4141\monpro_output_error_log.txt", write_mode);

        for i in 0 to 10 loop

            monpro_reset_n <= '0';
            wait for 10ns;
            monpro_reset_n <= '1';
            monpro_begin_monpro <= '0';

            readline(file_vectors,v_LINE_vector);
            read(v_LINE_vector, v_ADD_fasit);
            read(v_LINE_vector, v_ADD_a);
            read(v_LINE_vector, v_ADD_b);
            read(v_LINE_vector, v_ADD_n);

            monpro_a <= v_add_a;
            monpro_b <= v_add_b;
            monpro_n <= v_add_n;

            wait for 1ns;
            monpro_begin_monpro <= '1';

            wait on monpro_data_ready;

            if(monpro_data_out = v_add_fasit) then
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
        end loop;
        file_close(file_vectors);
        file_close(file_results);
        file_close(file_error_log);
    end process;

end Behavioral;
