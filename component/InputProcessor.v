// Input_Processor
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

/*
    Manage the input for keyboard scanner.
*/

module InputProcessor(
    input pressed,
    input [3:0]key_value,
    output reg start,
    output reg clear,
    output reg confirm,
    output reg press_num,
    output [3:0]value
    );

    assign value = key_value;

    always@(pressed)begin
        if(pressed) begin
            if(key_value == 4'b1010) begin
                confirm = 0;
                start = 1;
                clear = 0;
            end 
            else if(key_value == 4'b1011)begin
                confirm = 0;
                start = 0;
                clear = 1;
            end
            else if(key_value == 4'b1100)begin
                confirm = 1;
                start = 0;
                clear = 0;
            end
            press_num = (key_value < 4'b1010)? 1:0;
        end
        else begin
            clear <= 0;
            start <= 0;
            confirm <= 0;
            press_num <= 0;
        end
    end
    
endmodule
