// Testbench for Keyboard
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 10ns / 1ns
module keyboard_tb();


reg clk, rst_n;
reg[3:0] row;
wire[3:0] col, key_value;
wire press_num, start, clear, confirm;

reg[4:0] iter;


Keyboard kboard(
    .clk(clk),
    .rst_n(rst_n),
    .row(row),
    .col(col),
    .key_value(key_value),
    .press_num(press_num),
    .start(start),
    .clear(clear),
    .confirm(confirm)
    );


//Generate 50MHz clock signal
parameter ClockPeriod = 20;
initial begin
    clk = 0;
    always #(ClockPeriod/2) clk = ~ clk;
    end


initial begin
    rsn_n = 0; //Initial reset
    row = 4'b1111; //Assume that no keys are pressed in the initial state
    # 20000000; //0.02 second
    
    row = 4'b1101;
    

    end

initial begin
    $display("Simulation start !")
    #500
    end

endmodule