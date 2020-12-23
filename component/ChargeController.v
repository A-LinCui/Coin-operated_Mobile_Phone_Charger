// Charge Controller
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// Function: Controll the current state.
// State: Finshed

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
    
    //Reduce the frequency from 1000Hz to 1Hz 
    always@(posedge clk)
	begin    
        if(cnt == (NUM_DIV / 2)) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else cnt <= cnt + 1;
    end

    always@(posedge clk)
    begin
        if (rst_n) begin
            current_state <= S0;
            no_display <= 1;
        end
        if(current_state == S0) no_display <= 1; //When first power on, extinguish the digital tubes
        if (clk_div && !clk_div_prev) begin
            if (current_state == S4) begin
                remaining_time = remaining_time - 1;
                if (remaining_time == 0) begin
                    current_state <= S1;
                    all_money = 0;
                    remaining_time = 0;
                end
	    end 
            else begin
                inactive_time <= inactive_time + 1;
                if (inactive_time == 10) begin
                    no_display <= 1;
                    current_state <= S0;
                    all_money = 0;
                    remaining_time = 0;
                end
            end
        end

        if (start && !start_prev) begin
            inactive_time <= 0;
            if (current_state == S0) begin
                current_state <= S1;
                no_display <= 0;
                all_money = 0;
                remaining_time = 0;
            end
        end

        if (clear && !clear_prev) begin
            inactive_time <= 0;
            if (current_state == S2 || current_state == S3) begin
                current_state <= S1;
                all_money = 0;
                remaining_time = 0;
            end
        end

        if (press && !press_prev) begin
            inactive_time <= 0;
            if (current_state == S1) begin
                current_state <= S2;
                all_money = key_value;
		remaining_time = {all_money, 1'b0};
            end
            else if (current_state == S2) begin
                current_state <= S3;
                if (all_money < 2) all_money = 10 * all_money + key_value;
                else all_money = MAX;
		remaining_time = {all_money, 1'b0};
            end
        end

        if (confirm && !confirm_prev) begin
            inactive_time <= 0;
            if (current_state == S2 || current_state == S3) current_state <= S4;
        end

        clk_div_prev <= clk_div;
        clear_prev <= clear;
        confirm_prev <= confirm;
        start_prev <= start;
        press_prev <= press;
    end
	
endmodule
