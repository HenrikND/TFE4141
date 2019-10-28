library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity monprov2 is
  port (
    clock, reset_n : in std_logic;
    a, b, n : in std_logic_vector(255 downto 0);
    result : out std_logic_vector(255 downto 0);
    done : out std_logic;
    begin_monpro : in std_logic
  );
end monprov2;


architecture arch of monprov2 is

    signal S, P, Q, result_buf : unsigned(255 downto 0);
    signal a_shift,a_shift_buf, b_reg, n_reg : std_logic_vector(255 downto 0);
    signal counter : unsigned(8 downto 0);
    signal Q_buf : unsigned(255 downto 0);
    signal state : std_ulogic;

begin

    result <= std_logic_vector(result_buf);


    controller : process( clock, reset_n )
    begin
      if( reset_n = '0' ) then

        counter <= (others => '0');
        a_shift <= (others => '0');
        done <= '0';
      elsif( rising_edge(clock) ) then

        if begin_monpro = '1' then

          counter <= (others => '0');
          a_shift <= a;
          done <= '0';

        else
          if counter(8) = '1' then
              done <= '1';
          else
              done <= '0';

              a_shift(254 downto 0) <= a_shift(255 downto 1);
              a_shift(255) <= '0';

          end if ;

          if state = '1' and counter(8) = '0' then
            counter <= counter + 1;
          end if ;
        end if ;
      end if ;
    end process ; -- controller



    data_path : process( clock, reset_n )
    begin
      if( reset_n = '0' ) then
        state <= '0';
        Q <= (others => '0');
        result_buf <= (others => '0');
        S <= (others => '0');
        P <= (others  => '0');
        Q_buf <= (others => '0');
        b_reg <= (others => '0');
        n_reg <= (others => '0');

      elsif(rising_edge(clock)) then

        if begin_monpro = '1' then
          Q <= (others => '0');
          result_buf <= (others => '0');
          S <= (others => '0');
          P <= (others  => '0');
          Q_buf <= (others => '0');
          b_reg <= b;
          n_reg <= n;
          state <= '0';
        else
          if counter(8) = '1' then
              if Q > unsigned(n_reg) then
                  result_buf <= ('0' & Q(255 downto 1)) - unsigned(n_reg);
              else
                  result_buf <= '0' & Q(255 downto 1);
              end if ;
          else
              S <= '0' & Q(255 downto 1);
              case( state ) is
                  when '0' =>
                      if a_shift(0) = '1' then
                          P <= unsigned(b_reg) + S;
                      else
                          P <= S;
                      end if ;
                      state <= '1';
                  when '1' =>
                      if P(0) = '1' then
                          Q <= unsigned(n_reg) + P;
                      else
                          Q <= P;
                      end if ;
                      --Q <= Q(254 downto 0) & '0';
                      state <= '0';
              end case ;
          end if;
        end if;
      end if ;
    end process ; -- data_path



end arch ; -- arch
