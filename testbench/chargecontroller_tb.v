// Testbench for ChargeController
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Finished. The charge controller has passed all the test.

`timescale 100us / 100ns
module chargecontroller_tb();

reg clk, rst_n, press, clear, start, confirm;
reg [3:0]key_value;
wire no_display;
wire [4:0]all_money;
wire [5:0]remaining_time;
wire [2:0]current_state;


ChargeController controller(
    .clk(clk),
    .rst_n(rst_n),
    .key_value(key_value),
    .press(press),
    .clear(clear),
    .start(start),
    .confirm(confirm),
    .no_display(no_display),
    .all_money(all_money),
    .remaining_time(remaining_time),
    .current_state(current_state)
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


//Main test
initial begin
    clk = 0;
    key_value = 4'b0000;
    press = 0;
    clear = 0;
    start = 0;
    confirm = 0;
    #300;

    //Start
    start = 1;
    #50;
    start = 0;
    #500;

    //Input number 1
    key_value = 4'b0001;
    press = 1;
    #100;
    press = 0;
    key_value = 4'b0000;
    #500;

    //Clear
    clear = 1;
    #50;
    clear = 0;
    #500;

    //Input number 2
    key_value = 4'b0010;
    press = 1;
    #100;
    press = 0;
    key_value = 4'b0000;
    #500;

    //Confirm
    confirm = 1;
    #50;
    confirm = 0;
    #500;
end

initial begin
    $display("Simulation start !");
    $monitor($time,,, "rst_n = %d, key_value = %d, press = %d, clear = %d, start = %d, confirm = %d, no_display = %d, all_money = %d, remaining_time = %d, current_state = %d", rst_n, key_value, press, clear, start, confirm, no_display, all_money, remaining_time, current_state);
    #5000;
end

endmodule