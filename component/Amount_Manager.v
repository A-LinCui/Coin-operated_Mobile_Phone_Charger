// Amount_Manager
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Finish

/*
    Manage the input money as well as the remaining time.
    If the amount of input money is greater than 20, directly set it to 20.
*/

module Amount_Manager(
    input clk, //1000Hz after reduction
    input rst_n, //The signal to reset the FSM
    input start, //The signal that starts timing
    input pressed, //The signal that a number key is pressed
    input [3:0]key_value, //Value of the pressed key (0-9)
    output reg [4:0]all_money, //The money, binary
    output reg [5:0]remaining_time, //The remained time, binary
    output timing //The signal that is timing 
    );

    /* States of The Amount Manager.
        State 00 (S0)
        Explanation: Initial State. No input and not timing.
        Function: None.
        
        State 01 (S1)
        Explanation: One input is given.
        Function: Ready to start timing and to receive the next input number. 

        State 10 (S2)
        Explanation: Two inputs are given.
        Function: Ready to start timing.

        State 11 (S3)
        Explanation: Timing.
        Function: Timing.
    */


    reg [1:0] current_state, next_state; //Record current state and the following state
    reg [10:0]cnt;

    parameter NUM_DIV = 1000; //1000Hz to 1Hz
    parameter MAX = 5'b10100; //The maximum money
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    assign timing = (current_state == S3) & (remaining_time != 0);
 
    always@(posedge clk or posedge rst_n)
    begin
        if(rst_n) current_state = S0;
        else begin
        current_state = next_state;
        if(!timing) cnt <= 0;
        else cnt <= (cnt == NUM_DIV)? 0:(cnt + 1);
        end
    end

    always@(posedge pressed or posedge start or negedge timing)
    begin
        case(current_state)
            S0: next_state <= (pressed)? S1:S0;
            S1: if(start) next_state <= S3;
                else if (pressed) next_state <= S2;
            S2: if(start) next_state <= S3;
            S3: if(!timing) next_state <= S0;
        endcase
    end

    always@(current_state or rst_n or cnt)
    begin
        if(rst_n) begin
            remaining_time = 0;
            all_money = 0;
        end
        case(current_state)
            S0: begin
                remaining_time = 0;
                all_money = 0;
                end
            S1: begin
                all_money = {1'b0, key_value};
                remaining_time = 2'b10 * all_money;
                end
            S2: begin
                if (all_money > 5'b00010) all_money = MAX;
                else all_money = 5'b01010 * all_money + {1'b0, key_value};
                remaining_time = 2'b10 * all_money;
                end 
            S3: if(cnt == NUM_DIV) remaining_time = remaining_time - 1;
            endcase
    end
endmodule