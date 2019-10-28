library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity multicore is
    generic  (number_of_cores : integer := 5);
    port (
        clock, reset_n : in std_logic;
        e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
        data_out : out std_logic_vector(255 downto 0);
        data_ready : out std_logic
      ) ;
end multicore ;

architecture arch of multicore is
    component modexp is
        port (
            clock, reset_n : in std_logic;
            e, p, n, m, p_mon : in std_logic_vector(255 downto 0);
            data_out : out std_logic_vector(255 downto 0);
            data_ready : out std_logic
          ) ;
      end component;

    --g_gen_sig: for ii in 0 to 7 generate
      -- signal modexp_m_ii : std_logic_vector(255 downto 0);
      -- begin
    --end generate g_gen_sig;
      -- modexp conections
      --signal modexp_0,modexp_data_0,modexp_ready_0 : std_logic_vector(255 downto 0);
      --signal modexp_1,modexp_data_1,modexp_ready_1 : std_logic_vector(255 downto 0);
      --signal modexp_2,modexp_data_2,modexp_ready_2 : std_logic_vector(255 downto 0);
      --signal modexp_3,modexp_data_3,modexp_ready_3 : std_logic_vector(255 downto 0);

      type mem is array (0 to number_of_cores) of std_logic_vector(255 downto 0);
      signal modexp_m ,modexp_data: mem;
      signal modexp_ready : std_logic_vector(number_of_cores downto 0);
begin

-- generate the nessesary number of blocks
g_gen_modexp: for i in 0 to number_of_cores generate
    uut: modexp port map( clock => clock,
                            reset_n => reset_n,
                            e => e,
                            n => n,
                            p => p,
                            m => modexp_m(i),
                            p_mon => p_mon,
                            data_out => modexp_data(i),
                            data_ready => modexp_ready(i));
   end generate g_gen_modexp;

end architecture ; -- arch