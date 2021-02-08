module VGA_display (
    input               vga_clk,
    input               vga_rst_n,

    input       [ 3:0]  key,
    output  reg [15:0]  pixel_data ,
    input       [ 9:0]  pixel_xpos,
    input       [ 9:0]  pixel_ypos,
    output  reg         led
     
);

parameter  H_DISP  = 10'd640;                   //閿熻鎲嬫嫹閿熺粸鈽呮嫹閿熸枻鎷烽敓鏂ゆ嫹
parameter  V_DISP  = 10'd480;                   //閿熻鎲嬫嫹閿熺粸鈽呮嫹閿熸枻鎷烽敓鏂ゆ嫹

localparam SIDE_W  = 10'd40;                    //閿熺鍖℃嫹閿熸枻鎷烽敓鏂ゆ嫹
localparam snack_w = 10'd20;                    //璐敓鏂ゆ嫹閿熺鍖℃嫹閿熸枻鎷
localparam BLACK   = 16'b00000_000000_00000;    //閿熸枻鎷疯壊
localparam WHITE   = 16'b11111_111111_11111;    //閿熸枻鎷疯壊
localparam BLUE    = 16'b00000_000000_11111;    //閿熺即
localparam RED     = 16'b11111_000000_00000;    //閿熸枻鎷疯壊
localparam YELLOW  = 16'b00000_111111_11111;    //閿熸枻鎷疯壊
localparam RED_BLUE = 16'b11111_000000_11111;   //閿熸枻鎷疯壊

localparam POS_X  = 10'd272;                    //閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷峰閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹
localparam POS_Y  = 10'd4;                    //閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷峰閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹
localparam WIDTH  = 10'd96;                     //閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹
localparam HEIGHT = 10'd32;                     //閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熺璁规嫹

wire [ 9:0] x_cnt;
wire [ 9:0] y_cnt;

reg [ 9:0] snack_x[20:0];               //鍓0浣嶄负璐敓鏂ゆ嫹閿熺鎲嬫嫹閿熻剼锝忔嫹閿熸枻鎷0浣嶉敓瑙掔尨鎷烽敓鏂ゆ嫹閿熸枻鎷
reg [ 9:0] snack_y[20:0];               //鍓0浣嶄负璐敓鏂ゆ嫹閿熺鎲嬫嫹閿熻剼锝忔嫹閿熸枻鎷0浣嶉敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷
reg [ 3:0] direct;
reg [ 9:0] food_x;
reg [ 9:0] food_y;
reg [24:0] move_cnt;
reg [ 9:0] snack_l;                             //璐敓鏂ゆ嫹閿熺鐨勭鎷烽敓鏂ゆ嫹
//reg [ 9:0] snack_cnt;             //璐敓鏂ゆ嫹閿熺纭锋嫹閿熸枻鎷
reg [ 9:0] random_x;
reg [ 9:0] random_y;

reg  move_en;                                   //浣块敓鏂ゆ嫹閿熸枻鎷烽敓鐙¤鎷
reg  [95:0] char[31:0];                         //閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹

integer snack_cnt;
integer i;
integer u;

assign x_cnt = pixel_xpos - POS_X;              //閿熸枻鎷烽敓鎴鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷峰閿熸枻鎷锋按骞抽敓鏂ゆ嫹閿熸枻鎷
assign y_cnt = pixel_ypos - POS_Y;              //閿熸枻鎷烽敓鎴鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熻鍑ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹閿熸枻鎷峰閿熸枻鎷烽敓鏂ゆ嫹鐩撮敓鏂ゆ嫹閿熸枻鎷


always @(posedge vga_clk, negedge vga_rst_n) begin
    if(!vga_rst_n)
        led <= 1'd1;
    else
        led <= 1'd0;
end

always @(posedge vga_clk) begin             
    char[0]  <= 96'h000000000000000000000000;
    char[1]  <= 96'H000000000000000000000000;
    char[2]  <= 96'h001000000000000000000000;
    char[3]  <= 96'h001818000000000004000080;
    char[4]  <= 96'h001818100000000007FFFFC0;
    char[5]  <= 96'h001818380000002006000180;
    char[6]  <= 96'h3FFFFFFC07FFFFF006000180;
    char[7]  <= 96'h001818000000006006000180;
    char[8]  <= 96'h001818000000006006000180;
    char[9]  <= 96'h001818000000006006000180;
    char[10] <= 96'h041000000000026007FFFF80;    
    char[11] <= 96'h030200800000046006010180;
    char[12] <= 96'h0183FFE00000186006010000;
    char[13] <= 96'h00CB00C00000206006018000;
    char[14] <= 96'h009300800000C06006018000;
    char[15] <= 96'h181300800001806006018030;
    char[16]  <= 96'h0C1300800006006007FFFFF8;
    char[17]  <= 96'h06230080001C006006018000;
    char[18]  <= 96'h062300800030006006008000;
    char[19]  <= 96'h0043018000E000600600C000;
    char[20]  <= 96'h0043018003C000600600C000;
    char[21]  <= 96'h00830F800F00006006006000;
    char[22]  <= 96'h008307001E00006006006000;
    char[23]  <= 96'h198302080C0000C006003008;
    char[24]  <= 96'h07030008000000C006043808;
    char[25]  <= 96'h03030008000000C006181C08;
    char[26] <= 96'h03030018000071C006600E18;    
    char[27] <= 96'h0303801C00001FC007C00718;
    char[28] <= 96'h0301FFF8000007800F8003F8;
    char[29] <= 96'h0300000000000200060001F8;
    char[30] <= 96'h03000000000000000000003C;
    char[31] <= 96'h000000000000000000000000;
end

always @(posedge vga_clk, negedge vga_rst_n) begin //閿熸枻鎷锋椂0.8s
    if(!vga_rst_n) begin
        move_cnt <= 25'd20_000_000;
        move_en <= 1'd0;
    end
    else begin
        if(move_cnt == 25'd0) begin
            move_cnt <= 25'd20_000_000;
            move_en <= 1'd1;
        end
        else begin
            move_cnt <= move_cnt - 1'd1;
            move_en <= 1'd0;
        end
    end
end

always @(posedge vga_clk, negedge vga_rst_n) begin
    if (!vga_rst_n) begin
        direct <= 4'b0000;
    end
    else begin
        case(key)
            4'b1110:    begin
                if (direct[3]) 
                    direct <= 4'b1000;
                else
                    direct <= 4'b0001;
            end
            4'b1101:    
            begin
                if (direct[2]) 
                    direct <= 4'b0100;
                else
                    direct <= 4'b0010;
            end
            4'b1011:    
            begin
                if (direct[1]) 
                    direct <= 4'b0010;
                else
                    direct <= 4'b0100;
            end
            4'b0111:    
            begin
                if (direct[0]) 
                    direct <= 4'b0001;
                else
                    direct <= 4'b1000;
            end
            4'b1111:    direct <= direct;
            
            default:    direct <= 4'b0001;
        endcase
    end
end

always @(posedge vga_clk, negedge vga_rst_n) begin
    if (!vga_rst_n) begin
  //      for(u = 4'd1;u < 4'd9 ; u = u + 1'd1) begin
  //          snack_x[u] <= 10'd0;
  //          snack_y[u] <= 10'd0;
  //      end
        snack_x[0] <= 10'b0001_1001_00;  //閿熸枻鎷蜂竴閿熸枻鎷烽敓绔綇鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹100
        snack_y[0] <= 10'b0001_1001_00;  //閿熸枻鎷蜂竴閿熸枻鎷烽敓绔綇鎷烽敓鏂ゆ嫹閿熸枻鎷烽敓鏂ゆ嫹100
        snack_l <= 10'd1;
        food_x <= 10'd500;
        food_y <= 10'd400;
    end
    else begin
        if(move_en) begin
            case (direct)
                4'b1000: begin
                    snack_x[0] <= snack_x[0] -5'd20;
                    if(snack_x[0] == food_x + 5'd20 && snack_y[0] == food_y) begin
                        for (snack_cnt = 1'd1; snack_cnt <= 4'd9; snack_cnt = snack_cnt + 1'd1) begin
                            if (snack_l - snack_cnt + 1'd1 > 1'd0) begin
                                snack_x[snack_l - snack_cnt + 1'd1] <= snack_x[snack_l - snack_cnt ];
                                snack_y[snack_l - snack_cnt + 1'd1] <= snack_y[snack_l - snack_cnt ];
                            end
                        end 
                        snack_l <= snack_l + 1'd1; 
                        food_x <= random_x;
                        food_y <= random_y;
                    end
                    else begin
                        for (snack_cnt = 1'd1; snack_cnt < 4'd9; snack_cnt = snack_cnt + 1'd1) begin
                            if (snack_l - snack_cnt > 1'd0) begin
                                snack_x[snack_l - snack_cnt ] <= snack_x[snack_l - snack_cnt -1'd1];
                                snack_y[snack_l - snack_cnt ] <= snack_y[snack_l - snack_cnt -1'd1];
                            end  
                        end 
                    end       
                end
                4'b0100: begin
                    snack_y[0] <= snack_y[0] + 5'd20;
                    if(snack_x[0] == food_x && snack_y[0] == food_y - 5'd20) begin
                        for (snack_cnt = 1'd1; snack_cnt <= 4'd9; snack_cnt = snack_cnt + 1) begin
                            if (snack_l - snack_cnt + 1'd1 > 1'd0) begin
                                snack_x[snack_l - snack_cnt + 1'd1] <= snack_x[snack_l - snack_cnt ];
                                snack_y[snack_l - snack_cnt + 1'd1] <= snack_y[snack_l - snack_cnt ];
                            end
                        end
                        snack_l <= snack_l + 1'd1; 
                        food_x <= random_x;
                        food_y <= random_y;
                    end
                    else begin
                        for (snack_cnt = 1; snack_cnt < 4'd9; snack_cnt = snack_cnt + 1'd1) begin
                            if (snack_l - snack_cnt > 1'd0) begin
                                snack_x[snack_l - snack_cnt ] <= snack_x[snack_l - snack_cnt -1'd1];
                                snack_y[snack_l - snack_cnt ] <= snack_y[snack_l - snack_cnt -1'd1];
                            end  
                        end 
                    end        
                end
                4'b0010: begin
                    snack_y[0] <= snack_y[0] - 5'd20;
                    if(snack_x[0] == food_x && snack_y[0] == food_y + 5'd20) begin
                        for (snack_cnt = 1; snack_cnt <= 4'd9; snack_cnt = snack_cnt + 1) begin
                            if (snack_l - snack_cnt + 1 > 1'd0) begin
                                snack_x[snack_l - snack_cnt + 1'd1] <= snack_x[snack_l - snack_cnt ];
                                snack_y[snack_l - snack_cnt + 1'd1] <= snack_y[snack_l - snack_cnt ];
                            end
                        end
                        snack_l <= snack_l + 1'd1;
                        food_x <= random_x;
                        food_y <= random_y;
                    end
                    else begin
                        for (snack_cnt = 1'd1; snack_cnt < 4'd9; snack_cnt = snack_cnt + 1) begin
                            if (snack_l - snack_cnt > 1'd0) begin
                                snack_x[snack_l - snack_cnt ] <= snack_x[snack_l - snack_cnt -1'd1];
                                snack_y[snack_l - snack_cnt ] <= snack_y[snack_l - snack_cnt -1'd1];
                            end  
                        end 
                    end        
                end
                4'b0001: begin
                    snack_x[0] <= snack_x[0] + 5'd20;
                    if(snack_x[0] == food_x - 5'd20 && snack_y[0] == food_y) begin
                        for (snack_cnt = 1'd1; snack_cnt <= 4'd9; snack_cnt = snack_cnt + 1'd1) begin
                            if (snack_l - snack_cnt + 1'd1 > 1'd0) begin
                                snack_x[snack_l - snack_cnt + 1'd1] <= snack_x[snack_l - snack_cnt ];
                                snack_y[snack_l - snack_cnt + 1'd1] <= snack_y[snack_l - snack_cnt ];
                            end
                        end
                        snack_l <= snack_l + 1'd1; 
                        food_x <= random_x;
                        food_y <= random_y;
                    end
                    else begin
                        for (snack_cnt = 1'd1; snack_cnt < 4'd9; snack_cnt = snack_cnt + 1'd1) begin
                            if (snack_l - snack_cnt > 1'd0) begin
                                snack_x[snack_l - snack_cnt ] <= snack_x[snack_l - snack_cnt -1'd1];
                                snack_y[snack_l - snack_cnt ] <= snack_y[snack_l - snack_cnt -1'd1];
                            end  
                        end 
                    end       
                end
            endcase
        end
        else begin
            random_x <= 10'd600 - snack_y[snack_l/2];
            random_y <= 10'd600 - snack_x[snack_l/2];
            if(random_y > 10'd420 || random_y < 10'd40)
                random_y <= 10'd40;
            if(random_x > 10'd580 || random_x < 10'd40)
                random_x <= 10'd60;
        end
    end
end

always @(posedge vga_clk, negedge vga_rst_n) begin
    if(!vga_rst_n)
        pixel_data <= BLACK;
    else begin
        if(pixel_xpos < 6'd40 || pixel_xpos >10'd600 || pixel_ypos < 6'd40 || pixel_ypos > 10'd440) begin
            if(pixel_xpos <= 10'd368 && pixel_xpos >= 10'd272 && pixel_ypos <= 6'd36 && pixel_ypos >= 3'd4)begin
                if(char[y_cnt][10'd95 - x_cnt])
                    pixel_data <= RED;              //閿熸枻鎷烽敓鏂ゆ嫹閿熻鍑ゆ嫹涓洪敓鏂ゆ嫹鑹
                else
                    pixel_data <= YELLOW;             //閿熸枻鎷烽敓鏂ゆ嫹閿熻鍑ゆ嫹閿熸枻鎷烽敓娲ヨ儗鎾呮嫹涓洪敓缂
            end 
            else pixel_data <= BLACK;                  //閿熺鍖℃嫹閿熻鐚存嫹鑹  
        end
        else 
            if((pixel_xpos >= snack_x[0]) && (pixel_xpos < snack_x[0] + snack_w)
          && (pixel_ypos >= snack_y[0]) && (pixel_ypos < snack_y[0] + snack_w))  
          pixel_data <= RED;
          
          else if((pixel_xpos >= food_x) && (pixel_xpos < food_x + snack_w)
          && (pixel_ypos >= food_y) && (pixel_ypos < food_y + snack_w))
                     pixel_data <= BLUE;
          else pixel_data <= WHITE;
          
         
          
          
        
end        
    
    

end

endmodule