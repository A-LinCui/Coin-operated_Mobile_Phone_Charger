// Testbench for Amount Manager
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 100us / 100ns

module amount_manager_tb();


reg clk, rst_n, start, pressed;
reg[3:0] key_value;
wire[4:0] all_money;
wire[5:0] remaining_time;
wire timing;

Amount_Manager AM(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .pressed(pressed),
    .key_value(key_value),
    .all_money(all_money),
    .remaining_time(remaining_time),
    .timing(timing)
    );

//Generate 1000Hz clock signal
parameter ClockPeriod = 10;
always #(ClockPeriod / 2) clk = ~clk;

//Generate the initial RESET signal
parameter RESET_TIME = 100;
initial begin
    rst_n = 1'b1;
    #(RESET_TIME);
    rst_n = 1'b0;
end

//Main test
initial begin
    clk = 0;
    pressed = 0;
    start = 0;
    key_value = 0;
    #150;

    //Experiment 1
    
    //The first input
    //The output money should be 8 and the remaining_time should be 16
    key_value = 8;
    pressed = 1;
    #50;
    pressed = 0;
    #50;

    //The second input
    //The output money should be 20 and the remaining_time should be 40
    key_value = 9;
    pressed = 1;
    #50;
    pressed = 0;
    #50;

    //The third input
    //The outputs shouldn't change 
    key_value = 1;
    pressed = 1;
    #50;
    pressed = 0;
    #50;

    //Experiment 2
    //Generate the RESET signal
    rst_n = 1'b1;
    #(RESET_TIME);
    rst_n = 1'b0;

    //The first input
    //The output money should be 1 and the remaining_time should be 2
    key_value = 1;
    pressed = 1;
    #50;
    pressed = 0;
    #50;

    //The second input
    //The output money should be 15 and the remaining_time should be 30
    key_value = 5;
    pressed = 1;
    #50;
    pressed = 0;
    #50;

    start = 1;
    #2000000;
    end

initial begin
    $display("Simulation start !");
    $monitor($time,,, "rst_n = %d, start = %d, key_value = %d, all_money = %d, remaining_time = %d, timing = %d", rst_n, start, key_value, all_money, remaining_time, timing);
    #2100000;
end

endmodule