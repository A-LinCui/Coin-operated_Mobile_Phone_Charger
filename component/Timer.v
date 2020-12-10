// Timer (Finite-State Machine)
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module Timer(
    input clk,
    input reset, //Reset signal
    input start, //The signal to start timing
    output reg timing //The signal at the end of timing
    );

    /* States of the timer
        State 0
        Explanation: Initial State.
        Function: Wait for timing.

        State 1
        Explanation: Timing State.
        Function: Ten seconds timing.
    */

    reg current_state, next_state;
    reg [29:0]cnt;

    parameter S0 = 1'b0, S1 = 1'b1;
    parameter MAXTIME = 500000000;

    always@(posedge clk or posedge reset)
	begin
        if (reset) current_state <= S0;
        else begin
            current_state <= next_state;
            if (current_state == S1) cnt <= cnt + 1;
            else if (current_state == S0) cnt <= 0;
        end 
	end

    always@(current_state or start or cnt)
	begin
        case(current_state)
            S0: next_state <= start? S1:S0;
            S1: next_state <= (cnt == MAXTIME)? S0:S1;
        endcase
    end

    always@(current_state)
    begin
        case(current_state)
            S0: timing <= 0;
            S1: timing <= 1;
        endcase
    end

endmodule