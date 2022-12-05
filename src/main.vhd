library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is

port (
i_clk : in STD_LOGIC;
i_rst : in STD_LOGIC;
i_data : in STD_LOGIC_VECTOR (7 downto 0);
o_data : out STD_LOGIC_VECTOR (7 downto 0);
r1_load : in STD_LOGIC;
r2_load : in STD_LOGIC;
r3_load : in STD_LOGIC;
r4_load : in STD_LOGIC;
r5_load : in STD_LOGIC;
ff1_load : in STD_LOGIC;
ff2_load : in STD_LOGIC;
ff3_load : in STD_LOGIC;
ff4_load : in STD_LOGIC;
r3_sel : in STD_LOGIC;
r4_sel : in STD_LOGIC;
r5_sel : in STD_LOGIC;
ff2_sel : in STD_LOGIC;
ff3_sel : in STD_LOGIC;
ff4_sel : in STD_LOGIC;
d_sel : in STD_LOGIC;
o1_end : out STD_LOGIC;
o2_end : out STD_LOGIC;
count : out STD_LOGIC_VECTOR (7 downto 0)
);

end datapath;

architecture datapath_architecture of datapath is

signal o_reg1 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg2 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg3 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg4 : STD_LOGIC_VECTOR (2 downto 0);
signal o_reg5 : STD_LOGIC_VECTOR (15 downto 0);
signal o_ff1 : STD_LOGIC;
signal o_ff2 : STD_LOGIC;
signal o_ff3 : STD_LOGIC;
signal o_ff4 : STD_LOGIC;
signal mux_reg3 : STD_LOGIC_VECTOR (7 downto 0);
signal mux_reg4 : STD_LOGIC_VECTOR (2 downto 0);
signal mux_reg5 : STD_LOGIC_VECTOR (15 downto 0);
signal mux_ff1 : STD_LOGIC;
signal mux_ff2 : STD_LOGIC;
signal mux_ff3 : STD_LOGIC;
signal mux_ff4 : STD_LOGIC;
signal sum1 : STD_LOGIC_VECTOR (2 downto 0);
signal sum2 : STD_LOGIC_VECTOR (15 downto 0);
signal sum3 : STD_LOGIC_VECTOR (15 downto 0);
signal sub1 : STD_LOGIC_VECTOR (7 downto 0);
signal sub2 : STD_LOGIC_VECTOR (7 downto 0);
signal conv_in : STD_LOGIC_VECTOR (2 downto 0);
signal conv_out : STD_LOGIC_VECTOR (3 downto 0);
begin

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg1 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r1_load = '1') then
                o_reg1 <= i_data;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg2 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r2_load = '1') then
                o_reg2 <= i_data;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg3 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r3_load = '1') then
                o_reg3 <= mux_reg3;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg4 <= "000";
        elsif i_clk'event and i_clk = '1' then
            if(r4_load = '1') then
                o_reg4 <= mux_reg4;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg5 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r5_load = '1') then
                o_reg5 <= mux_reg5;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_ff1 <= '0';
        elsif i_clk'event and i_clk = '1' then
            if(ff1_load = '1') then
                o_ff1 <= mux_ff1;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_ff2 <= '0';
        elsif i_clk'event and i_clk = '1' then
            if(ff2_load = '1') then
                o_ff2 <= mux_ff2;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_ff3 <= '0';
        elsif i_clk'event and i_clk = '1' then
            if(ff3_load = '1') then
                o_ff3 <= mux_ff3;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_ff4 <= '0';
        elsif i_clk'event and i_clk = '1' then
            if(ff4_load = '1') then
                o_ff4 <= mux_ff4;
            end if;
        end if;
    end process;
    
    sum1 <= "001" + o_reg4;
    
    sum2 <= ("000000000000000" & o_ff4) + sum3;
    
    sum3 <= o_reg5 + o_reg5;
    
    sub1 <= o_reg3 - "00000001";
    
    sub2 <= o_reg1 - o_reg3;
    
    with r3_sel select
        mux_reg3 <= o_reg1 when '0',
                    sub1 when '1',
                    "XXXXXXXX" when others;
                    
    with r4_sel select
        mux_reg4 <= "000" when '0',
                    sum1 when '1',
                    "XXX" when others;
                    
    with r5_sel select
        mux_reg5 <= "0000000000000000" when '0',
                    sum2 when '1',
                    "XXXXXXXXXXXXXXXX" when others;
                    
    with o_reg4 select
        mux_ff1 <= o_reg2(7) when "000",
                   o_reg2(6) when "001",
                   o_reg2(5) when "010",
                   o_reg2(4) when "011",
                   o_reg2(3) when "100",
                   o_reg2(2) when "101",
                   o_reg2(1) when "110",
                   o_reg2(0) when "111",
                   'X' when others;
                    
    with ff2_sel select
        mux_ff2 <= '0' when '0',
                   conv_out(1) when '1',
                   'X' when others;
                    
    with ff3_sel select
        mux_ff3 <= '0' when '0',
                   conv_out(0) when '1',
                   'X' when others;
                    
    with ff4_sel select
        mux_ff4 <= conv_out(3) when '0',
                   conv_out(2) when '1',
                   'X' when others;
                   
    with d_sel select
        o_data <= o_reg5(15 downto 8) when '0',
                  o_reg5(7 downto 0) when '1',
                  "XXXXXXXX" when others;
                  
    conv_in <= o_ff1 & o_ff2 & o_ff3;
    
    with conv_in select
        conv_out <= "0000" when "000",
                    "1100" when "001",
                    "0101" when "010",
                    "1001" when "011",
                    "1110" when "100",
                    "0010" when "101",
                    "1011" when "110",
                    "0111" when "111",
                    "XXXX" when others;
    
    o1_end <= '1' when (o_reg3 = "00000000") else '0';
    o2_end <= '1' when (o_reg4 = "111") else '0';
    count <= sub2;

end datapath_architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project_reti_logiche is
port (
i_clk : in STD_LOGIC;
i_rst : in STD_LOGIC;
i_start : in STD_LOGIC;
i_data : in STD_LOGIC_VECTOR(7 downto 0);
o_data : out STD_LOGIC_VECTOR (7 downto 0);
o_address : out STD_LOGIC_VECTOR(15 downto 0);
o_done : out STD_LOGIC;
o_en : out STD_LOGIC;
o_we : out STD_LOGIC
);
end project_reti_logiche;

architecture fsm_architecture of project_reti_logiche is
    
component datapath is

port (
i_clk : in STD_LOGIC;
i_rst : in STD_LOGIC;
i_data : in STD_LOGIC_VECTOR (7 downto 0);
o_data : out STD_LOGIC_VECTOR (7 downto 0);
r1_load : in STD_LOGIC;
r2_load : in STD_LOGIC;
r3_load : in STD_LOGIC;
r4_load : in STD_LOGIC;
r5_load : in STD_LOGIC;
ff1_load : in STD_LOGIC;
ff2_load : in STD_LOGIC;
ff3_load : in STD_LOGIC;
ff4_load : in STD_LOGIC;
r3_sel : in STD_LOGIC;
r4_sel : in STD_LOGIC;
r5_sel : in STD_LOGIC;
ff2_sel : in STD_LOGIC;
ff3_sel : in STD_LOGIC;
ff4_sel : in STD_LOGIC;
d_sel : in STD_LOGIC;
o1_end : out STD_LOGIC;
o2_end : out STD_LOGIC;
count : out STD_LOGIC_VECTOR (7 downto 0)
);

end component;
    
signal r1_load : STD_LOGIC;
signal r2_load : STD_LOGIC;
signal r3_load : STD_LOGIC;
signal r4_load : STD_LOGIC;
signal r5_load : STD_LOGIC;
signal ff1_load : STD_LOGIC;
signal ff2_load : STD_LOGIC;
signal ff3_load : STD_LOGIC;
signal ff4_load : STD_LOGIC;
signal r3_sel : STD_LOGIC;
signal r4_sel : STD_LOGIC;
signal r5_sel : STD_LOGIC;
signal ff2_sel : STD_LOGIC;
signal ff3_sel : STD_LOGIC;
signal ff4_sel : STD_LOGIC;
signal d_sel : STD_LOGIC;
signal o1_end : STD_LOGIC;
signal o2_end : STD_LOGIC;
signal count : STD_LOGIC_VECTOR (7 downto 0);
type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15);
signal cur_state, next_state : S;
begin
    
    DATAPATH0 : datapath port map(
        i_clk,
        i_rst,
        i_data,
        o_data,
        r1_load,
        r2_load,
        r3_load,
        r4_load,
        r5_load,
        ff1_load,
        ff2_load,
        ff3_load,
        ff4_load,
        r3_sel,
        r4_sel,
        r5_sel,
        ff2_sel,
        ff3_sel,
        ff4_sel,
        d_sel,
        o1_end,
        o2_end,
        count
    );
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif i_clk'event and i_clk = '1' then   
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state,i_start,o1_end,o2_end)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 => 
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 => 
                next_state <= S3;
            when S3 =>
                next_state <= S4;
            when S4 => 
                if o1_end = '1' then
                    next_state <= S14;
                else
                    next_state <= S5;
                end if;
            when S5 => 
                next_state <= S6;
            when S6 => 
                next_state <= S7;
            when S7 => 
                next_state <= S8;
            when S8 =>
                next_state <= S9;
            when S9 => 
                next_state <= S10;
            when S10 => 
                next_state <= S11;
            when S11 => 
                if o2_end = '1' then
                    next_state <= S12;
                else
                    next_state <= S7;
                end if;
            when S12 => 
                next_state <= S13;
            when S13 => 
                next_state <= S4;
            when S14 => 
                if i_start = '0' then
                    next_state <= S15;
                end if;
            when S15 => 
                next_state <= S0;
        end case;
    end process;
    
    process(cur_state,count)
    begin
        r1_load <= '0';
        r2_load <= '0';
        r3_load <= '0';
        r4_load <= '0';
        r5_load <= '0';
        ff1_load <= '0';
        ff2_load <= '0';
        ff3_load <= '0';
        ff4_load <= '0';
        r3_sel <= '0';
        r4_sel <= '0';
        r5_sel <= '0';
        ff2_sel <= '0';
        ff3_sel <= '0';
        ff4_sel <= '0';
        d_sel <= '0';
        o_address <= "0000000000000000";
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        case cur_state is
            when S0 =>
            when S1 =>
                o_address <= "0000000000000000";
                o_en <= '1';
                o_we <= '0';
                ff2_sel <= '0';
                ff2_load <= '1';
                ff3_sel <= '0';
                ff3_load <= '1';
            when S2 =>
                r1_load <= '1';
            when S3 =>
                r3_sel <= '0';
                r3_load <= '1';
            when S4 =>
                r3_sel <= '1';
                r3_load <= '1';
                r4_sel <= '0';
                r4_load <= '1';
                r5_sel <= '0';
                r5_load <= '1';
            when S5 =>
                o_address <= ("00000000" & count);
                o_en <= '1';
                o_we <= '0';
            when S6 =>
                r2_load <= '1';
            when S7 =>
                ff1_load <= '1';
            when S8 =>
                ff4_sel <= '0';
                ff4_load <= '1';
            when S9 =>
                r5_sel <= '1';
                r5_load <= '1';
            when S10 =>
                ff4_sel <= '1';
                ff4_load <= '1';
            when S11 =>
                r5_sel <= '1';
                r5_load <= '1';
                r4_sel <= '1';
                r4_load <= '1';
                ff2_sel <= '1';
                ff2_load <= '1';
                ff3_sel <= '1';
                ff3_load <= '1';
            when S12 =>
                d_sel <= '0';
                o_address <= "0000001111100110" + ("00000000" & count) + ("00000000" & count);
                o_en <= '1';
                o_we <= '1';
            when S13 =>
                d_sel <= '1';
                o_address <= "0000001111100111" + ("00000000" & count) + ("00000000" & count);
                o_en <= '1';
                o_we <= '1';
            when S14 =>
                o_done <= '1';
            when S15 =>
                o_done <= '0';
        end case;
    end process;
    
end fsm_architecture;