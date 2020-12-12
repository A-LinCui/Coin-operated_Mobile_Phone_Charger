// Testbench for Timer
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 100us / 100ns
module timer_tb();

reg clk;
reg reset;
reg start;
wire timing;

Timer t_timer(
    .clk(clk),
    .reset(reset),
    .start(start),
    .timing(timing)
    );

//Generate 1000Hz clock signal
parameter ClockPeriod = 10;
always #(ClockPeriod / 2) clk = ~clk;

//Generate the initial RESET signal
parameter RESET_TIME = 10;
initial begin
    reset = 1'b1;
    #(RESET_TIME);
    reset = 1'b0;
end

initial begin
    start = 0;
    clk = 0;
    #15;
    start = 1;
    #200000;
end

//Only test the timer for one time
always@(negedge timing)
begin
    start <= 0;
end

//Main
initial begin
    $display("Simulation start !");
    $monitor($time,,, "reset = %d, start = %d, timing = %d", reset, start, timing);
    #1000000;
end

endmodule