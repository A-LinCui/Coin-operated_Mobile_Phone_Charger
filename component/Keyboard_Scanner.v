// Keyboard
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module Keyboard(
    input clk, //1000Hz after reduction
    input rst_n, //The signal to reset the FSM
    input [3:0]row, //x-axis
    output reg [3:0]col, //y-axis
    output reg [3:0]key_value, //The key value signal passed to the AmountManager
    output reg press_num, //The signal that a number key is pressed, passed to ChargeController
    output reg start, //The signal that the key "START" is pressed, passed to ChargeController
    output reg clear, //The signal that the key "CLEAR" is pressed, paseed to ChargeController as "RESET"
    output reg confirm //The signal that the key "CONFIRM" is pressed, passed to ChargeController
    );

    reg [2:0] current_state, next_state; //Record current state and the following state
    reg [5:0] cnt;
    reg end_timing, _break;

    parameter MAX = 4'b1111; //Stabilization. Valid if no change in 15 ms
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4=3'b100, S5=3'b101;
    parameter no_press = 4'b1111; //High voltage if not pressed

    always@(posedge clk or posedge rst_n)
    begin
        current_state <= (rst_n)? S0:next_state;
    end

    always@(current_state or end_timing or _break)
    begin
        case(current_state)
            S0: next_state <= (row == no_press)? S0:S1;
            S1: next_state <= (row == no_press)? S2:S5;
            S2: next_state <= (row == no_press)? S3:S5;
            S3: next_state <= (row == no_press)? S4:S5;
            S4: next_state <= (row == no_press)? S0:S5;
            S5: 
                if (row == no_press) next_state <= S0;
                else if (_break) next_state <= S0;
                else if (end_timing) next_state <= S0;
                else next_state <= S5;
        endcase
    end

    always@(posedge clk)
    begin
        if (current_state != S5) begin
            cnt <= 0;
            _break <= 0;
            end_timing <= 0;
        end
        else if(row == no_press) _break <= 1;
        else if (cnt < MAX) cnt <= cnt + 1;
        else if (cnt == MAX) end_timing <= 1;
    end

    always@(current_state or end_timing)
    begin
        case(current_state)
            S0: begin
                col <= 4'b0000;
                press_num <= 0;
                start <= 0;
                clear <= 0;
                confirm <= 0;
                end
            S1: col <= 4'b0111;
            S2: col <= 4'b1011;
            S3: col <= 4'b1101;
            S4: col <= 4'b1110;
            S5:  
                if(end_timing) begin
                    case({col, row})
                        8'b01110111: begin
                            key_value <= 4'b0001; //1
                            press_num <= 1;
                            end
                        8'b10110111: begin
                            key_value <= 4'b0010; //2
                            press_num <= 1;
                            end
                        8'b11010111: begin
                            key_value <= 4'b0011; //3
                            press_num <= 1;
                            end
                        8'b11100111: begin
                            key_value <= 4'b0100; //4
                            press_num <= 1;
                            end
                        8'b01111011: begin
                            key_value <= 4'b0101; //5
                            press_num <= 1;
                            end
                        8'b10111011: begin
                            key_value <= 4'b0110; //6
                            press_num <= 1;
                            end
                        8'b11011011: begin
                            key_value <= 4'b0111; //7
                            press_num <= 1;
                            end
                        8'b11101011: begin
                            key_value <= 4'b1000; //8
                            press_num <= 1;
                            end
                        8'b01111101: begin
                            key_value <= 4'b1001; //9
                            press_num <= 1;
                            end
                        8'b10111101: begin
                            key_value <= 4'b0000; //0
                            press_num <= 1;
                            end
                        8'b01111110: start <= 1;
                        8'b10111110: clear <= 1;
                        8'b11011110: confirm <= 1;
                    endcase
                end
        endcase
    end
endmodule