// Testbench for Timer
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 10ns / 1ns
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


//Generate 50MHz clock signal
parameter ClockPeriod = 20;
initial begin
    clk = 0;
    //TODO: Are you kidding me? There's no bug at all!
    always #(ClockPeriod / 2) clk = ~clk;
end


parameter RESET_TIME = 100;
initial begin
    //Generate the RESET signal
    reset = 1'b1;
    #(RESET_TIME);
    reset = 1'b0;
end


initial begin
    //clk = 0;
    reset = 0;
    start = 0;
    #150;
    start = 1;
end

initial begin
    $display("Simulation start !");
    $monitor($time,,, "reset = %d, start = %d, timing = %d", reset, start, timing);
    #100000;
end

endmodule