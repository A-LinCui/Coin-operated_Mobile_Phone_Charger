// ScanModule
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// Function: Manage the final output to lights and tubes.
// State: Finshed. Passed all test.

module ScanModule(
    input clk,
    input [3:0]money_1,
    input [3:0]money_2,
    input [3:0]time_1,
    input [3:0]time_2,
    input LT,
    input RBI,
    input BI,
    input no_display,
    input [2:0] current_state,
    output light_1,
    output light_2,
    output light_3,
    output light_4,
    output [6:0]display,
    output [4:0]statelight
    );

    wire[3:0]data;

    OutputScanner used_outputScan(
        .clk(clk),
        .no_display(no_display),
        .money_1(money_1),
        .money_2(money_2),
        .time_1(time_1),
        .time_2(time_2),
        .data(data),
        .light_1(light_1),
        .light_2(light_2),
        .light_3(light_3),
        .light_4(light_4)
    );

    Standard_7448 used_7448(
        .data(data),
        .LT(LT),
        .RBI(RBI),
        .BI(BI),
        .display(display)
    );
	 
	 
    StateDisplayer st_displayer(
        .clk(clk),
        .state(current_state),
        .light(statelight)
    );

endmodule