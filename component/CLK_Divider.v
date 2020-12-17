// Clock Divider
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Finshed

// Reduce the frequency from 50MHz to 1000Hz.
// The output signal serves as the global clock.

module CLK_Divider(
    input clk,
    output reg clk_div
    );
    
    parameter NUM_DIV = 50000; //50MHz to 1000Hz
    reg [14:0] cnt;
    
    always@(posedge clk)
    begin
        if(cnt < NUM_DIV / 2 - 1) cnt <= cnt + 1;
        else begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
    end
endmodule