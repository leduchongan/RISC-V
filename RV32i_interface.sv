`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 03:25:06 PM
// Design Name: 
// Module Name: RV32i_interface
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
`include "define.vh"
interface RV32i_if(input bit clk);
    logic rst_n;
    logic start_in;
    logic [`WORD_BITS-1:0] INST_Addr_in;
    logic [`WORD_BITS-1:0] INST_Data_in;
    logic                  INST_We_in;
    logic [`WORD_BITS-1:0] DMEM_Addr_in;
    logic [`WORD_BITS-1:0] DMEM_Data_in;
    logic                  DMEM_We_in;
    logic [`WORD_BITS-1:0] DMEM_Data_out;
    logic                  Met_jr_ra;
    
    clocking cb @(posedge clk);
        default input #1ns output;
        output rst_n;
        output start_in;
        output INST_Addr_in;
        output INST_Data_in;
        output INST_We_in;
        output DMEM_Addr_in;
        output DMEM_Data_in;
        output DMEM_We_in;
        input  DMEM_Data_out;
        input  Met_jr_ra;
    endclocking
    modport TB(clocking cb, output rst_n);
        
endinterface