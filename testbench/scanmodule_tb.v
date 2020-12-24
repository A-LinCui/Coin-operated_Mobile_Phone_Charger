// Testbench for Scan Module
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Finished. The scanmodule has passed all the test.

`timescale 100us / 10ns
module scanmodule_tb();


reg [3:0]money_1, money_2, time_1, time_2;
reg clk, LT, RBI, BI, no_display;
reg [2:0]current_state;
wire light_1, light_2, light_3, light_4;
wire [4:0]statelight;
wire [6:0] display;


ScanModule used_scanmodule(
    .clk(clk),
    .money_1(money_1),
    .money_2(money_2),
    .time_1(time_1),
    .time_2(time_2),
    .LT(LT),
    .RBI(RBI),
    .BI(BI),
    .no_display(no_display),
    .current_state(current_state),
    .light_1(light_1),
    .light_2(light_2),
    .light_3(light_3),
    .light_4(light_4),
    .display(display),
    .statelight(statelight)
    );

//Generate 1000Hz clock signal
parameter ClockPeriod = 10;
always #(ClockPeriod / 2) clk = ~clk;

initial begin
    LT = 0;
    RBI = 0;
    BI = 0;
    clk = 0;
    money_1 = 0;
    money_2 = 0;
    time_1 = 0;
    time_2 = 0;
    no_display = 1;
    current_state = 1;
    #100;

    money_1 = 1;
    money_2 = 2;
    time_1 = 2;
    time_2 = 4;
    no_display = 0;
    current_state = 3;
    #100;
end


initial begin
    $display("Simulation start !");
    $monitor($time,,, "LT = %d, RBI = %d, BI = %d, money_1 = %d, money_2 = %d, time_1 = %d, time_2 = %d, no_display = %d, current_state = %d, statelight = %d, display = %d, light_1 = %d, light_2 = %d, light_3 = %d, light_4 = %d", LT, RBI, BI, money_1, money_2, time_1, time_2, no_display, current_state, statelight, display, light_1, light_2, light_3, light_4);
    #500;
end

endmodule