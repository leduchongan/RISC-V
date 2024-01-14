`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 10:47:10 PM
// Design Name: 
// Module Name: test
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
`include "Packet.sv"
program automatic test_packet(RV32i_if.TB RISCV);
int pkts_generated = 0;
bit [31:0] inst_arr[0:1023];
string name = "pkt2send";
string name_new;
class gen;
    bit start_gene;
    bit [1:0] constraint_select;
    task start_gen();
        if (start_gene) begin
            generator();
        end
    endtask
    task generator();
        Packet pkt2send;
        pkt2send = new();
        for (int i=0; i<1000; i++) begin
            $display("/////////////////LOOP%d//////////", i);
            pkt2send.display();
            pkt2send.select_constraint(constraint_select);
            assert(pkt2send.randomize()) begin
                $display("Randomize Successful");
            end else begin
                $display("Randomize Occured an Error!");
                $stop;
            end
        pkt2send.Packet_generate();
        inst_arr[i] = pkt2send.instruction;
        $display("instruction in inst_arr[%d] = %h", i, inst_arr[i-1]);
        pkts_generated++;
        end
    endtask
endclass

class driver_DUT;
    extern task reset();
    extern task send_inst();
    extern task start();
endclass

task driver_DUT::reset();
    RISCV.rst_n = 1'b0;  
    RISCV.cb.start_in <= 1'b0;
    RISCV.cb.INST_We_in <= 1'b1;
    RISCV.cb.INST_Addr_in <= 32'b0;
    RISCV.cb.INST_Data_in <= 32'b0;
    RISCV.cb.DMEM_We_in <= 1'b0;
    repeat(1) @(RISCV.cb);
    RISCV.rst_n = 1'b1;
endtask

task driver_DUT::send_inst();
    for (int i = 0; i<pkts_generated; i = i+1) begin //Change value of `CFG_COUNT in "define.vh" file to set amount of Instructions will be written to Instruction Memory
        RISCV.cb.INST_Addr_in <= i<<2;
        RISCV.cb.INST_Data_in <= inst_arr[i];
        repeat(1) @(RISCV.cb);
    end
endtask

task driver_DUT::start();
    RISCV.cb.INST_We_in <= 1'b0;
    RISCV.cb.start_in <= 1'b1;
    repeat(520) @(RISCV.cb);
    $finish;
endtask
driver_DUT driver;
gen generator;
initial begin
    generator = new();
    generator.start_gene = 1'b1;
    generator.constraint_select = 2'b10;
    generator.start_gen();
    
    driver = new();
    driver.reset();
    driver.send_inst();
    driver.start();
end
endprogram
