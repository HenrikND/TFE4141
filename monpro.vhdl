library ieee;

entity monpro is
  port (
    clock, reset_n : in std_ulogic;
    a, b, n : in std_ulogic_vector(255 downto 0);
    result : out std_ulogic
  ) ;
end monpro;


architecture arch of ent is

    signal S, P, Q : unsigned(255 downto 0);
    signal a : std_ulogic_vector(255 downto 0);
    signal counter : std_ulogic_vector(9 downto 0)

begin

    adder_stage_1 : process(clock, reset_n)
        signal Q_buf : unsigned(255 downto 0);
        signal state : std_ulogic;
    begin
        if reset_n = '0' then
           p <= (others  => '1');
           Q_buf <= (others => '0');
        elsif rising_edge(clock) then
            case( state ) is
                when '0' =>
                    -- test case where the adding only happens when a(0) = '1'
                    if a(0) = '1' then
                        P = unsigned(b) + S;
                    else
                        P <= S
                    end if ;

                when '1' =>
                    if P(0) = '1' then
                        Q_buf <= unsigned(n) + P;
                    else
                        Q_buf <= P;
                    end if ;
                    Q <= Q_buf srl 1;
            end case ;
        end if ;
    end process ; -- adder_stage_1

    counter : process( clock,reset_n )
    begin
        if reset_n = '0' then
            counter <= (others => '0');
        end if ;
        if rising_edge(clock) then
            counter <= counter + 1;
        end if ;
    end process ; -- counter

end arch ; -- arch