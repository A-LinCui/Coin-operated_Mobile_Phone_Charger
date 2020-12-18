// Testbench for Keyboard
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 100us / 100ns
module keyboardscanner_tb();

reg clk, rst_n;
reg[3:0] row;
wire[3:0] col, key_value;
wire press_num, start, clear, confirm;
wire [2:0]current_state, next_state;
wire [5:0] cnt;
reg [1:0] exp;

Keyboard_Scanner keyboard(
    .clk(clk),
    .rst_n(rst_n),
    .row(row),
    .col(col),
    .key_value(key_value),
    .press_num(press_num),
    .start(start),
    .clear(clear),
    .confirm(confirm),
    .current_state(current_state),
    .next_state(next_state),
    .cnt(cnt)
    ); 


//Generate 1000Hz clock signal
parameter ClockPeriod = 10;
always #(ClockPeriod / 2) clk = ~clk;

//Generate the initial RESET signal
parameter RESET_TIME = 200;
initial begin
    rst_n = 1'b0;
    #20;
    rst_n = 1'b1;
    #(RESET_TIME);
    rst_n = 1'b0;
end

parameter no_press = 4'b1111;

//Main test
initial begin
    clk = 0;
    row = no_press;
    #300;
    

    //Input 4
    exp = 2'b00;
    row = 4'b0111;
    #1000;
    row = no_press;
    #300;

    //Shake: Fake input 4
    exp = 2'b01;
    row = 4'b0111;
    #100; //Fake shake for 10ms. 
    // As we can see, although state of the scanner turns to S5, however, output nothing
    row = no_press;
    #100;
    

    //Long-time input 2
    exp = 2'b10;
    row = 4'b0111;
    #40000; //4s 
    row = no_press;
    #300;
    
    
    //Input clear
    exp = 2'b11;
    row = 4'b1110;
    #500;
    row = no_press;
    #300;
end

always@(col)
begin
    if(exp == 2'b00) begin
        if(col == 4'b1110) row <= 4'b0111;
        else row <= no_press;
    end
    else if(exp == 2'b01) begin
        if(col == 4'b1110) row <= 4'b0111;
        else row <= no_press;
    end
    else if(exp == 2'b10) begin
        if(col == 4'b1011) row <= 4'b0111;
        else row <= no_press; 
    end
    else if(exp == 2'b11) begin
        if(col == 4'b1011) row <= 4'b1110;
        else row <= no_press; 
    end
end

initial begin
    $display("Simulation start !");
    $monitor($time,,, "exp = %d, rst_n = %d, row = %d%d%d%d, col = %d%d%d%d, key_value = %d, press_num = %d, start = %d, clear = %d, confirm = %d, current state = %d, next_state = %d", exp, rst_n, row[3], row[2], row[1], row[0], col[3], col[2], col[1], col[0], key_value, press_num, start, clear, confirm, current_state, next_state);
    #5000;
end

endmodule