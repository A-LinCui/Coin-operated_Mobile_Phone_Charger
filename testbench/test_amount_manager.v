// Testbench for Amount Manager
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 10ns / 1ns

module amount_manager_tb();

`define RESET_TIME 100

reg clk, rst_n, start;
reg[3:0] key_value;
wire[3:0] all_money;
wire[4:0] remaining_time;
wire timing;

reg[4:0] iter;


Amount_Manager AM(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .key_value(key_value),
    .all_money(all_money),
    .remaining_time(remaining_time),
    .timing(timing)
    );


//Generate 50MHz clock signal
parameter ClockPeriod = 20;
initial begin
    clk = 0;
    always #(ClockPeriod/2) clk = ~ clk;
end


//Main test
initial begin
    start = 0;
    key_value = 0;
    //Generate the RESET signal
    rst_n = 1'b1;
    #(`RESET_TIME);
    @(posedge clk);
    rst_n = 1'b0;
    #200;

    key_value = 8; //The output money should be 8 and the remaining_time should be 16
    #200;

    key_value = 9; //The output money should be 20 and the remaining_time should be 40
    #200;

    key_value = 1; //The outputs shouldn't change
    #200;

    //Generate the RESET signal
    rst_n = 1'b1;
    #(`RESET_TIME);
    @(posedge clk);
    rst_n = 1'b0;
    #200;

    key_value = 1; //The output money should be 1 and the remaining_time should be 2
    #200;

    key_value = 5; //The output money should be 15 and the remaining_time should be 30
    #200;

    start = 1;
    #2000000;
    end

initial begin
    $display("Simulation start !");
    $monitor($time,,, "rst_n = %d, start = %d, key_value = %d, all_money = %d, remaining_time = %d, timing = %d", rst_n, start, key_value, all_money, remaining_time, timing);
    #2100000;
end

endmodule