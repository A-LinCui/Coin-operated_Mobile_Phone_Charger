// Charger Controller (Finite-State Machine)
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module ChargeController(
    input clk,
    input init_reset, //Initial reset signal
    input start, //The signal to move current state from S0 to S1 
    input insert, //The signal that the storage gets a number 
    input reset, //The signal to reset the FSM
    input affirm, //The signal to move current state to S4
    input end_timing, //The signal that the timer stops timing
    output reg no_display, //The signal to extinguish the digital tubes
    output reg timing, //The siginal to start the charging
    output reg state_timing, //The siginal to start the ten-second counting-down of state S1
    output reg storage_reset, //Reset the storage to zero
    output reg timer_reset //Reset the timer
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
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

	always @ (posedge clk or posedge init_reset)
	begin
        if (init_reset) current_state <= S0;
        else current_state <= next_state;
	end

	always@(current_state or start or insert or affirm or end_timing or reset)
	begin
        if(reset) next_state <= S1;
        else begin
            case(current_state)
                S0: next_state <= start? S1:S0;
                S1: 
                    if(insert) next_state <= S2;
                    else if(end_timing) next_state <= S0;
                    else next_state <= S1;
                S2: next_state <= insert? S3:S2;
                S3: next_state <= affirm? S4:S3;
                S4: next_state <= end_timing? S1:S4;
            endcase
        end
    end

    always@(current_state or reset)
    begin
        if (~reset)
        begin
            case(current_state)
                S0:begin
                    no_display = 1;
                    timing = 0;
                    state_timing = 0;
                    storage_reset = 1;
                    timer_reset = 1;
                    end
                S1:begin
                    no_display = 0;
                    timing = 0;
                    state_timing = 1;
                    storage_reset = 0;
                    timer_reset = 0;
                    end
                S2:begin
                    no_display = 0;
                    timing = 0;
                    state_timing = 0;
                    storage_reset = 0;
                    timer_reset = 0;
                    end
                S3:begin
                    no_display = 0;
                    timing = 0;
                    state_timing = 0;
                    storage_reset = 0;
                    timer_reset = 0;
                    end
                S4:begin
                    no_display = 0;
                    timing = 1;
                    state_timing = 0;
                    storage_reset = 0;
                    timer_reset = 0;
                    end
            endcase
        end
        else begin
            storage_reset = 0;
            timer_reset = 0;
            end
    end
endmodule