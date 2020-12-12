// Timer
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module Timer(
    input clk, //1000Hz after reduction
    input reset, //Reset signal
    input start, //The signal to start timing
    output timing //The signal at the end of timing
    );

    parameter MAXTIME = 10000;
    reg[13:0] cnt;

    assign timing = start & (cnt != MAXTIME);

    always@(posedge clk or posedge reset)
    begin
        if(reset) cnt <= 0;
        else cnt <= start? (cnt + 1):0;
	end
    
endmodule