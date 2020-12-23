// Standard 7448
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

/*
    Although not used in this project
    in order to ensure the integrity of module functions
    some function design is carried out
*/

module Standard_7448(
    input [3:0]data, //Data(number 0-9) to be displayed
    input LT, //Test inputs (Case 1: Lighten all)
    input RBI, //Extinguish the zero output (Case 1: Extinguish)
    input BI, //Extinguish all (Case 1: Extinguish)
    output reg [6:0]display //Light signal (High voltage means lightenning)
    );
    parameter lighten_all = 7'b1111111, extinguish_all = 7'b0000000;
    always@(data or LT or RBI or BI)
    begin
        display = extinguish_all;
        if(~BI)
        begin
            if(LT) display = lighten_all;
            else
                case(data)
                    4'b0000:
                        if (RBI) display = extinguish_all;
                        else display = 7'b0111111; //Display 0
                    4'b0001: display = 7'b0000110; //Display 1
                    4'b0010: display = 7'b1011011; //Display 2
                    4'b0011: display = 7'b1001111; //Display 3
                    4'b0100: display = 7'b1100110; //Display 4
                    4'b0101: display = 7'b1101101; //Display 5
                    4'b0110: display = 7'b1111100; //Display 6
                    4'b0111: display = 7'b0000111; //Display 7
                    4'b1000: display = 7'b1111111; //Display 8
                    4'b1001: display = 7'b1100111; //Display 9          
                    4'b1010: display = 7'b1011000; //Display 10
                    4'b1011: display = 7'b1001100; //Display 11
                    4'b1100: display = 7'b1100001; //Display 12
                    4'b1101: display = 7'b1101001; //Display 13
                    4'b1110: display = 7'b1111000; //Display 14
                    4'b1111: display = 7'b0000000; //Display 15
                    default: display = extinguish_all; //Extinguish all
                endcase
        end
    end
endmodule