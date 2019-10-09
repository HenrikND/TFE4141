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

begin

    adder_stage_1 : process(clock, reset_n)
    begin
        if reset_n = '0' then
            -- not sure if needed
        elsif rising_edge(clock) then
            -- test case where the adding only happens when a(0) = '1'
            if a(0) = '1' then
                P = unsigned(b) + S;
            else
                P <= S
            end if ;
        end if ;
    end process ; -- adder_stage_1


    adder_stage_2 : process( clock, reset_n )
    begin
        if rising_edge(clock) then
            if P(0) = '1' then
                Q <= std_ulogic(unsigned(n) + P);
            else
                Q <= P;
            end if ;
            Q <= Q srl 1;
        end if ;
    end process ; -- adder_stage_2'


end arch ; -- arch