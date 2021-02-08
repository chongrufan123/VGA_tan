module vga_clk_curl(
    input       sys_clk,
    input       sys_rst_n,
    
    output      vga_clk
);

reg clk_cnt;
reg vga_clk_c;

always @(posedge sys_clk, negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        clk_cnt <= 1'd0;
        vga_clk_c <= 1'd0;
        end
    else  begin 
        if(clk_cnt == 1'd1) begin
            vga_clk_c <= 1'd1;
            clk_cnt <= 1'd0;
        end
        else if(clk_cnt == 1'd0) begin
            clk_cnt <= clk_cnt + 1;
            vga_clk_c <= 1'd0;
        end
    end
end

always@(posedge sys_clk, negedge sys_rst_n) begin
    if(!sys_rst_n)
        vga_clk <= 1'd0;
    else if(vga_clk_c == 1'd1)
        vga_clk <= ~vga_clk;
    else if(vga_clk_c == 1'd0)
        vga_clk <= vga_clk; 
end
endmodule
