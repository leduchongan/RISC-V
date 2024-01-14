`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2023 04:04:09 PM
// Design Name: 
// Module Name: RV32i_TestTop
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
module RV32i_TestTop();
    bit SystemClock;
    initial begin
        SystemClock = 1'b0;
        forever #5 SystemClock = ~SystemClock;
    end
    RV32i_if top_RV32i(SystemClock);
    test_packet RV32i_test(top_RV32i);
    RV32i_SingleCycle DUT(
        .clk(top_RV32i.clk), 
        .rst_n(top_RV32i.rst_n),
        .start_in(top_RV32i.start_in),
        .CFG_wea_in(top_RV32i.INST_We_in),
        .CFG_addr_in(top_RV32i.INST_Addr_in),
        .CFG_dina_in(top_RV32i.INST_Data_in),
        .LDM_wea_in(top_RV32i.DMEM_We_in),
        .LDM_addra_in(top_RV32i.DMEM_Addr_in),
        .LDM_dina_in(top_RV32i.DMEM_Data_in),
        .LDM_douta_out(top_RV32i.DMEM_Data_out),
        .Met_jr_ra(top_RV32i.Met_jr_ra)
    );
endmodule