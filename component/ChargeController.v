// Charge Controller
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// Function: Controll the current state.
// State: Finshed. Passed all test.

module ChargeController(
    input clk,
    input rst_n, //Initial reset signal
    input [3:0]key_value, //Input from the keyboard scanner
    input press,
    input clear,
    input start,
    input confirm,
    output reg no_display = 0, //The signal to extinguish the digital tubes
    output reg [4:0]all_money, //The money (binary)
    output reg [5:0]remaining_time, //The remained time (binary)
    output reg [2:0]current_state = 0 //Current state of the controller
    );

    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
    parameter MAX = 5'b10100; //The maximum money(20)
    parameter NUM_DIV = 1000; //Reduce the frequency from 1000Hz to 1Hz

    reg [3:0] inactive_time = 0; //Ten-second countdown
    reg press_prev = 0, start_prev = 0, clear_prev = 0, confirm_prev = 0;

    reg clk_div, clk_div_prev = 0;
    reg [10:0]cnt; //Remaining time reduction
    reg [2:0] next_state = 0;
    
    //Reduce the frequency from 1000Hz to 1Hz 
    always@(posedge clk)
	begin    
        if(cnt == (NUM_DIV / 2)) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else cnt <= cnt + 1;
    end

    always@(posedge clk or posedge rst_n)
    begin
        if(rst_n) current_state <= S0;
        else current_state <= next_state;    
    end

    always@(posedge clk)
    begin
        case(current_state)
            S0: begin
                if(rst_n) next_state = S0;
                no_display = 1;
                remaining_time = 0;
                all_money = 0;
                inactive_time = 0;
                if (start && !start_prev) next_state = S1;
                end
            S1: begin
                no_display = 0;
                if(press && !press_prev) begin
                    next_state = S2;
                    all_money = key_value;
		    remaining_time = {all_money, 1'b0};
                end
                if((clear && !clear_prev) || (confirm && !confirm_prev) || (start && !start_prev)) inactive_time = 0;
                if (clk_div && !clk_div_prev) begin
                    inactive_time = inactive_time + 1;
                    if(inactive_time == 10) next_state = S0;
                end
                end
            S2: if(press && !press_prev) begin
                    next_state <= S3;
                    if (all_money < 2) all_money = 10 * all_money + key_value;
                    else all_money = MAX;
		    remaining_time = {all_money, 1'b0};
                end
                else if (clear && !clear_prev) begin
                    inactive_time = 0;
                    all_money = 0;
                    remaining_time = 0;
                    next_state <= S1;
                end
                else if (confirm && !confirm_prev) next_state <= S4;
            S3: if (clear && !clear_prev) begin
                    inactive_time = 0;
                    all_money = 0;
                    remaining_time = 0;
                    next_state <= S1;
                end
                else if (confirm && !confirm_prev) next_state <= S4;
            S4: if (clk_div && !clk_div_prev) begin
                    remaining_time = remaining_time - 1;
                    if (remaining_time == 0) begin
                        all_money = 0;
                        inactive_time = 0;
                        next_state <= S1;
                    end
                end
        endcase
        clk_div_prev = clk_div;
        clear_prev = clear;
        confirm_prev = confirm;
        start_prev = start;
        press_prev = press;
    end
	
endmodule
