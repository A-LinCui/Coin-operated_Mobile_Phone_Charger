// Testbench for Keyboard
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 1ns / 1ps
module keyboard_tb();

reg clk, reset;
reg[3:0] row;
wire[3:0] col, key_value;
wire press_num, start, clear, confirm;

parameter ClockPeriod = 10 ;

initial begin
    clk = 0;
    always #(ClockPeriod/2) clk = ~ clk;
    end


Keyboard kboard(
    .clk(clk),
    .rst_n(reset),
    .row(row),
    .col(col),
    .key_value(key_value),
    .press_num(press_num),
    .start(start),
    .clear(clear),
    .confirm(confirm)
    ); 


initial begin
    end

initial begin
    $display("Simulation start !")
    #500
    $finish; 
    end

endmodule