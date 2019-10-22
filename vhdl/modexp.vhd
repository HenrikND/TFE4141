library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity modexp is
  port (
    clock, reset_n : in std_logic;
    e, p, n, m : in std_logic_vector(255 downto 0);
    data_out : out std_logic_vector(255 downto 0);
    data_ready : out std_logic
  ) ;
end modexp ;

architecture arch of modexp is
    component monprov2 is
      port(
        clock, reset_n : in std_logic;
        a, b, n : in std_logic_vector(255 downto 0);
        result : out std_logic_vector(255 downto 0);
        done : out std_logic;
        begin_monpro : in std_logic
      );
    end component;


    signal e_reg : std_logic_vector(255 downto 0);
    signal counter : unsigned(8 downto 0);
    signal s_mon : std_logic_vector(255 downto 0);
    signal c_begin, c_loop, c_loop_in, c_mon, c_mon_r: std_logic_vector(255 downto 0);
    signal state : std_logic_vector(1 downto 0);
    signal loop_state : std_logic_vector(1 downto 0);
    signal state_loop : std_logic;
    signal done_1, done_2, done_3: std_logic;
    signal begin_monpro_1, begin_monpro_2, begin_monpro_3, begin_monpro_4 : std_logic;
begin

  -- data path
    monpro_1 : monprov2 port map(clock => clock, reset_n => reset_n, begin_monpro => begin_monpro_1, a => P, b => (0 => '1', others => '0') , n => n, result => c_begin, done => done_1);
    monpro_2 : monprov2 port map(clock => clock, reset_n => reset_n, begin_monpro => begin_monpro_2, a => P, b => m , n => n, result => s_mon , done => done_2);
    monpro_3 : monprov2 port map(clock => clock, reset_n => reset_n, begin_monpro => begin_monpro_3, a => c_loop_in, b => c_loop , n => n, result => c_mon, done => done_3);
    monpro_4 : monprov2 port map(clock => clock, reset_n => reset_n, begin_monpro => begin_monpro_4, a => (0 => '1', others => '0'), b => c_mon_r , n => n, result => data_out, done => data_ready);

    controller : process( clock, reset_n )
    begin
        if reset_n = '0' then
          e_reg <= (others => '0');
          c_loop <= (others => '0');
          c_loop_in <= (others => '0');
          counter <= (others => '0');

        elsif (rising_edge(clock)) then
          case( state ) is
            when "00" =>
              begin_monpro_1 <= '1';
              begin_monpro_2 <= '1';
              state <= "01";

            when "01" =>
              begin_monpro_1 <= '0';
              begin_monpro_2 <= '0';
              if done_1 = '1' and done_2 = '1' then
                state <= "10";
                c_loop <= c_begin;
              end if ;

            when "10" =>
                case( loop_state ) is

                  when "00" =>
                    begin_monpro_3 <= '1';
                    loop_state <= "01";
                    counter <= counter + 1;

                  when "01" =>
                    begin_monpro_3 <= '0';
                    if done_3 = '1' and e(0) = '1' then
                      loop_state <= "10";
                    elsif done_3 = '1' and e(0) = '0' then
                      loop_state <= "00";
                    end if ;

                  when "10" =>
                    begin_monpro_3 <= '1';
                    loop_state <= "11";
                  when "11" =>
                    if done_3 = '1' and counter(8) = '1' then
                      state <= "11";
                    elsif done_3 = '1' and counter(8) = '0'  then
                      loop_state <= "00";
                    end if ;

                  when others =>
                    loop_state <= (others => '0');

                end case ;
            when "11" =>
              begin_monpro_4 <= '1';
            when others =>
              state <= "00";
          end case ;

          if e(0) = '1' then
            c_loop_in <= s_mon;
          else
            c_loop_in <= c_mon;
          end if ;

          if counter = 0 then
            c_loop <= c_begin;
          else
            c_loop <= c_mon;
          end if ;

          if c_mon > n then
            c_mon_r <= std_logic_vector(unsigned(c_mon) - unsigned(n));
          else
            c_mon_r <= c_mon;
          end if ;

        end if ;
    end process ; -- controller

end architecture ; -- arch

