// Testbench for Standard 7448
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

`timescale 1ns / 1ps
module standard_7448_tb();


reg[3:0] data;
reg LT;
reg RBI;
reg BI;
wire[6:0] display;

reg[3:0] iter;


Standard_7448 sd_7448(
    .data(data),
    .LT(LT),
    .RBI(RBI),
    .BI(BI),
    .display(display)
    ); 


initial begin
    LT = 0;
    RBI = 0;
    BI = 0;
    data = 4'b0000;

    // Stage 1: Test the basic function by display from zero to fifteen.
    for(iter = 0; iter < 4'b1111; i = i + 1) begin
        #10;
        data = iter;
    end
    
    // Stage 2: Test the function of 'LT'.    
    #10;
    LT = 1;

    // Stage 3: Test the function of 'RBI'.
    #10;
    LT = 0;
    RBI = 1;
    data = 4'b0000;

    // Stage 4: Test the function of 'BI'.
    #10;
    RBI = 0;
    BI = 1;
    data = 4'b0010;
    end

initial begin
    $display("Simulation start !")
    $display($time,,, "LT = %d, RBI = %d, BI = %d, data = %d, display = ", LT, RBI, BI, data, display);
    #500
    $finish; 
    end

endmodule