// Amount_Manager
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

/*
    Manage the input money as well as the remaining time.
    If the amount of input money is greater than 20, directly set it to 20.
*/

module Amount_Manager(
    input clk,
    input rst_n, //The signal to reset the FSM
    input start, //The signal that starts timing
    input [3:0]key_value, //Value of the pressed key (0-9)
    output reg [3:0]all_money, //The money, binary
    output reg [4:0]remaining_time, //The remained time, binary
    output reg timing //The timing signal 
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
    reg clk_div, timechange; 
    reg [24:0]cnt;

    parameter NUM_DIV = 50000000; //50MHz to 1Hz
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    parameter MAX = 20;

    // Divide the clock signal from 50MHz to 1Hz
    always@(posedge clk)
    begin
        if(cnt < NUM_DIV / 2 - 1)
        begin
            cnt <= cnt + 1'b1;
            clk_div <= clk_div;
	    end
        else 
        begin
            cnt <= 25'b0000000000000000000000000;
            clk_div <= ~clk_div;
	    end
    end
    
    always@(posedge clk or posedge rst_n)
    begin
        if(rst_n) current_state <= S0;
        else current_state <= next_state;
    end

    always@(current_state or key_value or start or (~timing))
    begin
        case(current_state)
            S0: next_state <= (key_value)? S1:S0;
            S1: 
                if(start) next_state <= S3; 
                else next_state <= (key_value)? S2:S1;
            S2:
                if(start) next_state <= S3;
                else next_state <= S2;
            S3:
                if(~timing) next_state <= S0;
                else next_state <= S3;
        endcase
    end

    always@(current_state or remaining_time)
    begin
        case(current_state)
            S0: begin
                timing <= 0;
                all_money <= 0;
		        timechange <= 0;
                end
            S1: begin
                all_money[3:0] <= key_value;
		        timechange <= 1;
                end
            S2: begin
		        timechange = 0;
                if (10 * key_value > MAX - all_money) all_money = MAX;
                else all_money = all_money + 10 * key_value;
                timechange = 1;
                end
            S3: timing <= (remaining_time == 0)? 0:1;
        endcase
    end

    always@(posedge clk_div or posedge timechange)
    begin
	    if(timechange) remaining_time <= 2 * all_money;   
        else if(current_state == S3) remaining_time <= remaining_time - 1;
    end
	
endmodule