// Ouput Scanner
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.
// Function: Scan the digital tube for digital output.
// State: Finished.

module OutputScanner(
    input clk, //1000Hz after reduction
    input no_display,
    input [3:0] money_1,
    input [3:0] money_2,
    input [3:0] time_1,
    input [3:0] time_2,
    output reg[3:0] data,
    output reg light_1,
    output reg light_2,
    output reg light_3,
    output reg light_4
    );

    reg [1:0] cnt;
    parameter MAX = 3;
	 
    always@(posedge clk)begin
        cnt <= (cnt == MAX)? 0:cnt + 1;
    end
    
    always@(cnt) begin
        case(cnt)
            2'b00: begin
                data <= money_1;
                light_1 <= !no_display;
                light_2 <= 0;
                light_3 <= 0;
                light_4 <= 0;
            end
            2'b01: begin
                data <= money_2;
                light_2 <= !no_display;
                light_1 <= 0;
                light_3 <= 0;
                light_4 <= 0;
            end
            2'b10: begin
                data <= time_1;
                light_3 <= !no_display;
                light_1 <= 0;
                light_2 <= 0;
                light_4 <= 0;
            end
            2'b11: begin
                data <= time_2;
                light_4 <= !no_display;
                light_3 <= 0;
                light_2 <= 0;
                light_1 <= 0;
            end
        endcase
    end

endmodule
