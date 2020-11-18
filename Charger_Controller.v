// Charger Controller (Finite-State Machine)
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module Charger_Controller(
    input clk,
    input start, //The signal to move current state from S0 to S1 
    input insert, //The signal that the storage gets a number 
    input reset, //The signal to reset the FSM
    input affirm, //The signal to move current state to S4
    input end_timing, //The signal that the timer stops timing
    input [5:0]current_time, //Current left time of timer
    output no_display, //The signal to extinguish the digital tubes
    output timing, //The siginal to start the charging
    output state_timing, //The siginal to start the ten-second counting-down of state S1
    output storage_reset, //Reset the storage to zero
    output timer_reset //Reset the timer
    );

    /* States of The Controller.
        State 000
        Explanation: Initial State. 
        Function: No digial tubes display.
        
        State 001
        Explanation: Start State.
        Function: Ready to pay. And digital tubes display '0000'.

        State 010
        Explanation: Input State I.
        Function: The first number of payment is given.

        State 011
        Explanation: Input State II.
        Function: The second number of payment is given.

        State 100
        Explanation: Charging State.
        Function: Charging.
    */ 

    reg [2:0] current_state, next_state; //Record current state and the following state
    reg _no_display, _timing, _state_timing, _storage_reset, _timer_reset;

    parameter S0 = 2'b000, S1 = 2'b001, S2 = 2'b010, S3 = 2'b011, S4 = 2'b100;

    assign no_display = _no_display;
    assign timing = _timing;
    assign state_timing = _state_timing;
    assign storage_reset = _storage_reset;
    assign timer_reset = _timer_reset; 
	 
    initial begin
        current_state = S0;
        next_state = S0;
        _no_display = 1;
        _timing = 0;
        _state_timing = 0;
        _storage_reset = 0;
        _timer_reset = 0;
    end
	 
    always@(posedge clk or posedge reset)begin
        if (reset)
            current_state <= next_state;
        else
            current_state <= S1;
    end

    always@(current_state or start or insert or affirm or end_timing)begin
        case(current_state)
        S0: next_state <= start? S0:S1;
        S1: begin
            if(insert)
                next_state <= S2;
            else if(end_timing)
                next_state <= S0;
            else
                next_state <= S1;
        end     
        S2: next_state <= insert? S3:S2;
        S3: next_state <= affirm? S4:S3;
        S4: next_state <= end_timing? S1:S4;
        endcase
    end

    always@(posedge clk or posedge reset)begin
        case(next_state)
            S0:begin
                _no_display = 1;
                _timing = 0;
                _state_timing = 0;
                _storage_reset = 1;
                _timer_reset = 1;
            end
            S1:begin
                _no_display = 0;
                _timing = 0;
                _state_timing = 1;
                _storage_reset = reset? 1:0;
                _timer_reset = reset? 1:0;
            end
            S2:begin
                _no_display = 0;
                _timing = 0;
                _state_timing = 0;
                _storage_reset = 0;
                _timer_reset = 0;
            end
            S3:begin
                _no_display = 0;
                _timing = 0;
                _state_timing = 0;
                _storage_reset = 0;
                _timer_reset = 0;
            end
            S4:begin
                _no_display = 0;
                _timing = 1;
                _state_timing = 0;
                _storage_reset = 0;
                _timer_reset = 0;
            end
        endcase
    end
endmodule