module VGA_tan (
	input   		sys_clk,
	input	    	sys_rst_n,
	input 	[ 3:0] 	key,
	output			vga_hs,
	output  		vga_vs,
	output  [15:0]	vga_rgb,
    output          led
);
	

//wire define
wire         vga_clk_w;             //PLL分频得到25Mhz时钟
wire         locked_w;              //PLL输出稳定信号
wire         rst_n_w;               //内部复位信号
wire [15:0]  pixel_data_w;          //���ص�����
wire [ 9:0]  pixel_xpos_w;          //���ص�������
wire [ 9:0]  pixel_ypos_w;          //���ص�������    

//��PLL�����ȶ�֮����ֹͣ��λ

assign rst_n_w = sys_rst_n && locked_w;

PLL u_pll(
	.areset      (~sys_rst_n),
	.inclk0      (sys_clk),
	.c0          (vga_clk_w),
	.locked      (locked_w)
   );


VGA_drive u_VGA_drive(
    .vga_clk        (vga_clk_w),    
    .sys_rst_n      (rst_n_w),    

    .vga_hs         (vga_hs),       
    .vga_vs         (vga_vs),       
    .vga_rgb        (vga_rgb),      
    
    .pixel_data     (pixel_data_w), 
    .pixel_xpos     (pixel_xpos_w), 
    .pixel_ypos     (pixel_ypos_w)
    ); 
    
VGA_display u_VGA_display(
    .vga_clk        (vga_clk_w),
    .vga_rst_n      (rst_n_w),
    
	.key			(key),
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w),
    .led            (led)
    );   

endmodule