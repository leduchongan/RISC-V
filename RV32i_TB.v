`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 11:59:32 PM
// Design Name: 
// Module Name: RV32i_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RV32i_TB();
    reg rst_n;
    reg clk;
    reg start_in;
    
    reg CFG_wea_in;
    reg [31:0] CFG_addr_in;
    reg [31:0] CFG_dina_in;
    reg [63:0] Inst_ROM [0:1024-1];
    
    reg LDM_wea_in;
    reg [31:0] LDM_addra_in;
    reg [31:0] LDM_dina_in;
    wire [31:0] LDM_douta_out;
    reg [63:0] Data_RAM [0:1024-1];
    wire Met_jr_ra;
    reg Met_jr_ra_rg;
    integer i,j;
    initial begin
        clk <= 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $readmemh("D:\\Verification\\LAB4\\RISCV_SingleCycle\\RISCV_SingleCycle.srcs\\sim_1\\new\\Inst_ROM.txt", Inst_ROM);    
        $readmemh("D:\\Verification\\LAB4\\RISCV_SingleCycle\\RISCV_SingleCycle.srcs\\sim_1\\new\\Data_RAM.txt", Data_RAM);   
        rst_n <= 1;
        start_in <= 0;
        #10;
        rst_n <= 0;
        #10;
        rst_n <= 1;
        #10;
        LDM_wea_in <= 1'b1;
        for (j = 0; j<18; j=j+1) begin
            {LDM_addra_in, LDM_dina_in} <= Data_RAM[j];
            #10;
        end
        LDM_wea_in <= 1'b0;
        #10;
        CFG_wea_in <= 1'b1;
        for (i = 0; i<`CFG_COUNT; i=i+1) begin  
            {CFG_addr_in, CFG_dina_in} <= Inst_ROM[i];
            #10;
        end
        CFG_wea_in <= 1'b0;
        //#15;       
        #5
        start_in <= 1'b1;
    end
    
    always@(posedge clk) begin
        if (Met_jr_ra) begin
            Met_jr_ra_rg <= Met_jr_ra;
            LDM_addra_in <= 32'h00000000;
        end
        if (Met_jr_ra_rg) begin           
            if (LDM_douta_out == 32'h00000001) begin
                start_in <= 1'b0;
                $stop;
            end 
        end        
    end
    RV32i_SingleCycle RV32i(
        .rst_n(rst_n),
        .clk(clk),
        .start_in(start_in),
        .CFG_wea_in(CFG_wea_in),
        .CFG_addr_in(CFG_addr_in),
        .CFG_dina_in(CFG_dina_in),
        .LDM_wea_in(LDM_wea_in),
        .LDM_addra_in(LDM_addra_in),
        .LDM_dina_in(LDM_dina_in),
        .LDM_douta_out(LDM_douta_out),
        .Met_jr_ra(Met_jr_ra)
    );
endmodule
