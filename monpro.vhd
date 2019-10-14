library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity monpro is
  port (
    clock, reset_n : in std_logic;
    a, b, n : in std_logic_vector(255 downto 0);
    result : out std_logic_vector(255 downto 0)
  );
end monpro;


architecture arch of monpro is

    signal S, P, Q, result_buf : unsigned(255 downto 0);
    signal a_shift,a_shift_buf : std_logic_vector(255 downto 0);
    signal counter : unsigned(8 downto 0);
    signal Q_buf : unsigned(255 downto 0);
    signal state : std_ulogic;

begin

    result <= std_logic_vector(result_buf);

    adder_stage_1 : process(clock, reset_n)
    begin
        -- reset process for the montgomery product
        if reset_n = '0' then
           P <= (others  => '0');
           Q_buf <= (others => '0');
           counter <= (others => '0');
           S <= (others => '0');
           state <= '0';
           a_shift <= (others => '0');
           Q <= (others => '0');
           result_buf <= (others => '0');

        -- Montgomery algorithm
        elsif rising_edge(clock) then
            if counter(8) = '1' then
                if Q > unsigned(n) then
                    result_buf <= ('0' & Q(255 downto 1)) - unsigned(n);
                else
                    result_buf <= '0' & Q(255 downto 1);
                end if ;
            else
                -- shift register of a
                if counter = 0 then -- boot
                    a_shift <= a;
                    S <= (others => '0');
                else
                    a_shift(254 downto 0) <= a_shift(255 downto 1);
                    a_shift(255) <= '0';
                end if ;
                S <= '0' & Q(255 downto 1);
                case( state ) is
                    when '0' =>
                        if a_shift(0) = '1' then
                            P <= unsigned(b) + S;
                        else
                            P <= S;
                        end if ;
                        state <= '1';
                    when '1' =>
                        if P(0) = '1' then
                            Q <= unsigned(n) + P;
                        else
                            Q <= P;
                        end if ;
                        --Q <= Q(254 downto 0) & '0';

                        counter <= counter + 1;
                        state <= '0';
                end case ;
            end if ;
        end if ;
    end process ; -- adder_stage_1

end arch ; -- arch
