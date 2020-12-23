// StateDisplayer
// Function: Display the state of the controller to luminous diodes.
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Finished.

module StateDisplayer(
    input clk,
    input [2:0] state,
    output reg[4:0] light
    );

    always@(posedge clk)
    begin
        case(state)
            4'b0000: light = 5'b10000;
            4'b0001: light = 5'b01000;
            4'b0010: light = 5'b00100;
            4'b0011: light = 5'b00010;
            4'b0100: light = 5'b00001;
            default: light = 5'b00000;
        endcase
    end
    
endmodule
