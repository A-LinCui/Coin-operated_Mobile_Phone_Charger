// Amount Translator
// Author: Junbo Zhao <zhaojb17@mails.tsinghua.edu.cn>.

module AmountTranslator(
    input [4:0] all_money,
    input [5:0] remaining_time,
    output reg[3:0] money_1,
    output reg[3:0] money_2,
    output reg[3:0] time_1,
    output reg[3:0] time_2
    );
    
    always @ * begin
        money_1 = all_money / 10;
        money_2 = all_money % 10;
	    time_1 = remaining_time / 10;
        time_2 = remaining_time % 10;
    end

endmodule