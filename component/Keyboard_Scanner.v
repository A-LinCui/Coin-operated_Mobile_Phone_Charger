// Keyboard Scanner
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// State: Finished. Passed all test.

module Keyboard_Scanner(
    input clk, //1000Hz after reduction
    input rst_n, //The signal to reset the FSM
    input [3:0]row, //x-axis
    output reg [3:0]col, //y-axis
    output reg [3:0]key_value, //The key value signal passed to the AmountManager
    output reg press //The signal that a key is pressed, passed to ChargeController
    );
    
    reg [2:0]current_state;
    reg [5:0]cnt;

    parameter MAX = 4'b1111; //Stabilization. Valid if no change in 15 ms
    parameter no_press = 4'b1111; //High voltage if not pressed
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4=3'b100, S5=3'b101; //All possible states

    always@(posedge clk)
    begin
	if (rst_n) begin
	    col = 4'b0000;
	    cnt = 0;
	    press = 0;
	    key_value = 4'b0000;
	    current_state = S0;
	end
        case(current_state)
            S0: if (row == no_press) begin
		    col = 4'b0000;
		    press = 0;
                    cnt = 0;
                    key_value = 4'b0000;
		end
                else begin
                    col = 4'b0111;
                    current_state = S1;
                end
            S1: if(row == no_press) begin
                    col = 4'b1011;
                    current_state = S2;
                end
                else current_state = S5;
            S2: if(row == no_press) begin
                    col = 4'b1101;
                    current_state = S3;
                end
                else current_state = S5;
            S3: if(row == no_press) begin
                    col = 4'b1110;
                    current_state = S4;
                end
                else current_state = S5;
            S4: if(row == no_press) begin
                    col = 4'b0000;
                    current_state = S0;
                end
                else current_state = S5;
            S5: if(row == no_press) begin
                    current_state = S0;
                    col = 4'b0000;
                end
                else if (cnt < MAX) cnt = cnt + 1;
                else begin
                    case({col, row})
                        8'b01110111: begin
                            key_value = 4'b0001; //1
                            press = 1;
                            end
                        8'b10110111: begin
                            key_value = 4'b0010; //2
                            press = 1;
                            end
                        8'b11010111: begin
                            key_value = 4'b0011; //3
                            press = 1;
                            end
                        8'b11100111: begin
                            key_value = 4'b0100; //4
                            press = 1;
                            end
                        8'b01111011: begin
                            key_value = 4'b0101; //5
                            press = 1;
                            end
                        8'b10111011: begin
                            key_value = 4'b0110; //6
                            press = 1;
                            end
                        8'b11011011: begin
                            key_value = 4'b0111; //7
                            press = 1;
                            end
                        8'b11101011: begin
                            key_value = 4'b1000; //8
                            press = 1;
                            end
                        8'b01111101: begin
                            key_value = 4'b1001; //9
                            press = 1;
                            end
                        8'b10111101: begin
                            key_value = 4'b0000; //0
                            press = 1;
                            end
                        8'b01111110: begin
                            key_value = 4'b1010; //10, start;
                            press = 1;
                            end
                        8'b10111110: begin
                            key_value = 4'b1011; //11, clear;
                            press = 1;
                            end
                        8'b11011110: begin
                            key_value = 4'b1100; //12, confirm;
                            press = 1;
                            end
                    endcase
                end
        endcase
    end
endmodule
