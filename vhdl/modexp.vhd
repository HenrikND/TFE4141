entity modexp is
  port (
    clock, reset_n : in std_logic;
    e : in std_logic_vector(255 down to 0)
  ) ;
end modexp ;

architecture arch of modexp is
-- import monpro
    e_reg : std_logic_vector(255 downto 0);
    counter : unsigned(8 downto 0);
    s_mon : std_logic_vector(255 downto 0);
    c: std_logic_vector(255 downto 0);
    state : unsigned(2 downto 0);
    state_loop : std_logic;
begin

    controller : process( clock, reset_n )
    begin
        if reset_n = '0' then
          e_reg <= (others => '0')
        elsif (rising_edge(clock)) then

        end if ;
    end process ; -- controller



    datapath : process( clock, reset_n )
    begin
      if( reset_n = '0' ) then

      elsif(rising_edge(clock)) then
        case(state) is
          when 0 =>
            --monpro(M,p,n,s_mon)
            --monpro(P,1,n,C)
            state = 1;
          when 1 =>
            if state_loop = '1' then
              -- monpro(s_mon, C, n, C)
            else
              -- monpro(C, C, n, C)
            end if ;
          when 2 =>
            --monpro(1,C,n,data_out)
          when others =>
            -- state = 0
        end case ;
      end if ;
    end process ; -- datapath


end architecture ; -- arch

