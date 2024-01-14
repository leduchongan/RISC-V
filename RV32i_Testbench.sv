`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 03:34:37 PM
// Design Name: 
// Module Name: RV32i_Testbench
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
program automatic test (RV32i_if.TB RISCV);
    reg [63:0] Inst_MEM [0:1023];
    reg [63:0] Data_MEM [0:1023];
    reg Met_jr_ra_rg;
    reg done;
    initial begin
        readmem();
        reset();
        push_inst_data();
        start();
        check_done();
    end
    task readmem();
        $readmemh("D:\\Verification\\LAB4\\RISCV_SingleCycle\\RISCV_SingleCycle.srcs\\sim_1\\new\\Inst_ROM.txt", Inst_MEM);    
        $readmemh("D:\\Verification\\LAB4\\RISCV_SingleCycle\\RISCV_SingleCycle.srcs\\sim_1\\new\\Data_RAM.txt", Data_MEM);   
    endtask
    task reset();
        RISCV.rst_n = 1'b0;
        RISCV.cb.start_in <= 1'b0;
        RISCV.cb.INST_We_in <= 1'b1;
        RISCV.cb.INST_Addr_in <= 32'b0;
        RISCV.cb.INST_Data_in <= 32'b0;
        RISCV.cb.DMEM_Addr_in <= 32'b0;
        RISCV.cb.DMEM_Data_in <= 32'b0;
        RISCV.cb.DMEM_We_in <= 1'b1;  
        repeat(1) @(RISCV.cb);
        RISCV.rst_n = 1'b1;           
    endtask
    
    task push_inst_data();
        for (int i = 0; i<`CFG_COUNT; i = i+1) begin //Change value of `CFG_COUNT in "define.vh" file to set amount of Instructions will be written to Instruction Memory
            RISCV.cb.INST_Addr_in <= Inst_MEM[i][63:32];
            RISCV.cb.INST_Data_in <= Inst_MEM[i][31:0];
            repeat(1) @(RISCV.cb);
        end
        for (int i = 0; i<`DMEM_COUNT; i = i+1) begin //Change value of `DMEM_COUNT in "define.vh" file to set amount of Instructions will be written to Data Memory
             RISCV.cb.DMEM_Addr_in <= Data_MEM[i][63:32];
             RISCV.cb.DMEM_Data_in <= Data_MEM[i][31:0];
             repeat(1) @(RISCV.cb);
        end       
    endtask
    
    task start();
        RISCV.cb.INST_We_in <= 1'b0;
        RISCV.cb.DMEM_We_in <= 1'b0;
        RISCV.cb.start_in <= 1'b1;       
    endtask
    
    task check_done();
        while (1) begin
            repeat(1) @(RISCV.cb);
            if (RISCV.cb.Met_jr_ra) begin
                Met_jr_ra_rg <= RISCV.cb.Met_jr_ra;
                RISCV.cb.DMEM_Addr_in <= 32'h00000000;
            end
            if (Met_jr_ra_rg) begin           
                if (RISCV.cb.DMEM_Data_out == 32'h00000001) begin
                    RISCV.cb.start_in <= 1'b0;
                    done = 1;
                    
                end 
            end 
            ///GET VALUE OUT FOR SAD ALGORITHM
            repeat(1) @(RISCV.cb);
            if (done == 1) begin
                RISCV.cb.DMEM_Addr_in <= 32'h00000050;
                repeat(1) @(RISCV.cb);
                $display("SAD_VALUE = %d", RISCV.cb.DMEM_Data_out);
                $stop;
            end
            //GET VALUE OUT FOR ABS_MINUS:
//            if (done == 1) begin
//                for (int i = 1; i<4; i=i+1)begin
//                    RISCV.cb.DMEM_Addr_in <= (i<<2);
//                    repeat(1) @(RISCV.cb);
//                    $display("result[%d] = %d", i, RISCV.cb.DMEM_Data_out);   
//                end
//                $stop;
//            end
        end       
    endtask
    
endprogram
