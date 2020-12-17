// Amount_Manager
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Debug

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
    reg clk_div;
    reg [10:0]cnt;

    parameter NUM_DIV = 1000; //1000Hz to 1Hz
    parameter MAX = 5'b10100; //The maximum money
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    wire change_time = (remaining_time != 2'b10 * all_money) & (current_state != S3); //While not timing, the remaining time should always be two times of money
    assign timing = (current_state == S3) & (remaining_time!=0);

    // Divide the clock signal from 1000Hz to 1Hz
    always@(posedge clk)
    begin
        if (current_state != S3) begin
            cnt <= 0;
            clk_div <= 0;
        end
        else if(cnt < NUM_DIV / 2 - 1) cnt <= cnt + 1'b1;
        else begin
            cnt <= 0;
            clk_div <= ~clk_div;
	    end
    end
    
    // Reset
    always@(posedge clk or posedge rst_n)
    begin
        current_state <=(rst_n)? S0:next_state;
    end

    always@(rst_n, pressed or start or (~timing))
    begin
        if(rst_n) all_money <= 0;  //Clear the registed money 
        case(current_state)
            S0: begin
                next_state <= (pressed)? S1:S0;
                all_money <= (pressed)? key_value:0;
                end
            S1: 
                if(start) next_state <= S3;
                else if(pressed) begin
                    if ({1'b0, key_value} > MAX - 5'b01010 * all_money) all_money <= MAX;
                    else all_money <= 5'b01010 * all_money + key_value;
                    next_state <= S2;
                end
            S2:
                if(start) next_state <= S3;
            S3:
                if(~timing) begin
                    next_state <= S0;
                    all_money <= 0;
                end
        endcase
    end

    // Change the remaining time when the money changes. 
    // Else, change the remaining time when timing.
    always@(posedge clk_div or posedge change_time or posedge rst_n)
    begin
        if(rst_n) remaining_time <= 0;
        else if(change_time) remaining_time <= 2'b10 * all_money;
        else if(current_state == S3) remaining_time <= remaining_time - 1;
    end

endmodule