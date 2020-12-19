// Charger Controller (Finite-State Machine)
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module ChargeController(
    input clk,
    input rst_n, //Initial reset signal
    input [3:0]key_value, //Input from the keyboard scanner
    input press,
    output reg no_display, //The signal to extinguish the digital tubes
    output timing, //The siginal that is charging
    output reg [4:0]all_money, //The money, binary
    output reg [5:0]remaining_time, //The remained time, binary
    output reg [2:0]current_state,
    output reg [2:0]next_state
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

	// reg [2:0] current_state, next_state; //Record current state and the following state
	
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
    parameter clear = 4'b1011, start = 4'b1010, confirm = 4'b1100;
    parameter MAX = 5'b10100; //The maximum money
    parameter max_waiting = 10000; //1000Hz to 10 seconds

    //10-second-counting for S1
    reg [13:0] waiting_time;

    always@(posedge clk)  //10-second-counting for S1
    begin
        if(current_state != S1) waiting_time <= 0;
        else if(waiting_time < max_waiting) waiting_time <= waiting_time + 1; 
    end


    //Remaining time reduction 
    reg [10:0]cnt;
    parameter NUM_DIV = 1000; //1000Hz to 1Hz

    always@(posedge clk) //1000Hz to 1Hz to reduce remaining time
    begin
        if(current_state != S4) cnt <= 0;
        else cnt <= (cnt == NUM_DIV)? 0:cnt + 1;
    end


    assign timing = (current_state == S4) & (remaining_time != 0);
    
	
    always@(posedge clk or posedge rst_n)
    begin
        if (rst_n) current_state <= S0;
        else current_state <= next_state;
	end

	
    always@(press or timing or rst_n or waiting_time)
	begin
        next_state = next_state;
        if(rst_n) next_state = S0;
        case(current_state)
            S0: next_state = (press & (key_value == start))? S1:S0;
            S1: if(waiting_time == max_waiting) next_state = S0; 
                else if (press & (key_value < 4'b1010)) next_state = S2;
            S2: if(press & (key_value < 4'b1010)) next_state = S3;
                else if(key_value == clear) next_state = S1;
                else if(key_value == confirm) next_state = S4;
            S3: if(key_value == confirm) next_state = S4;
                else if(key_value == clear) next_state = S1;
            S4: next_state = (timing)? S1:S4;
        endcase
    end
    
    
    always@(current_state or rst_n or cnt)
    begin
        if (rst_n) begin
            all_money = 0;
            remaining_time = 0;
        end
        case(current_state)
            S0: begin
                no_display = 1;
                all_money = 0;
                remaining_time = 0;
                end
            S1: begin
                all_money = 0;
                remaining_time = 0;
                no_display = 0;
                end
            S2: begin
                all_money = {1'b0, key_value};
                remaining_time = 2'b10 * all_money;
                end
            S3: begin
                if (all_money > 5'b00010) all_money = MAX;
                else all_money = 5'b01010 * all_money + {1'b0, key_value};
                remaining_time = 2'b10 * all_money;
                end
            S4: if((cnt == NUM_DIV) & (remaining_time != 0)) remaining_time = remaining_time - 1;
        endcase
    end

endmodule