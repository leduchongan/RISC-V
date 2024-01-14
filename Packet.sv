`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 12:29:59 PM
// Design Name: 
// Module Name: Packet
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
class Packet;
    rand bit [6:0] opcode; //random port selection
    rand bit [4:0] rs1,rs2,rd;
    rand bit [11:0] imm;
    rand bit [19:0] imm_20;
    rand bit [2:0] funct3;
    rand bit [6:0] funct7;
    string name;
    bit [31:0] instruction;
    constraint load_store_group{//Load, Store
        opcode inside {7'b0000011, 7'b0100011};
        if (opcode == 7'b0000011){
            funct3 inside {[0:5]};
        }
        if (opcode == 7'b0100011) {
            funct3 inside {[0:2]};
        }
    };
    constraint integer_group{//R-type, I-type, LUI, AUIPC
        opcode inside {7'b0110011, 7'b0010011, 7'b0110111, 7'b0010111};
        if (opcode == 7'b0110011){
            if(funct3 == 3'b000 || funct3 == 3'b101){
                funct7 inside {7'b0100000, 7'b0000000};
            }
            else funct7 == 7'b0000000;
        }
        if (opcode == 7'b0010011){
            if (funct3 == 3'b101){
                funct7 inside {7'b0100000, 7'b0000000};
            }
            else funct7 == 7'b0000000;
        }
    };
    constraint branch_jump_group{//JAL, JALR, Branch + Load, Store
        opcode inside {7'b1101111, 7'b1100111, 7'b1100011, 7'b0000011, 7'b0100011};
        if (opcode == 7'b1100111) {
            funct3 == 0;
        }
        if (opcode == 7'b0000011){
            funct3 >= 0;
            funct3 <= 5;
        }
        if (opcode == 7'b0100011) {
            funct3 >= 0;
            funct3 <= 2;
        }
    };
    constraint all_instruction {
        opcode inside {7'b0000011, 7'b0100011,7'b1101111, 7'b0110011, 7'b0010011, 7'b0110111, 7'b0010111, 7'b1100111, 7'b1100011};
        if (opcode == 7'b0000011){
            funct3 >= 0;
            funct3 <= 5;
        }
        if (opcode == 7'b0100011) {
            funct3 >= 0;
            funct3 <= 2;
        }
        if (opcode == 7'b0110011){
            if(funct3 == 3'b000 || funct3 == 3'b101){
                funct7 inside {7'b0100000, 7'b0000000};
            }
            else funct7 == 7'b0000000;
        }
        if (opcode == 7'b0010011){
            if (funct3 == 3'b101){
                funct7 inside {7'b0100000, 7'b0000000};
            }
            else funct7 == 7'b0000000;
        }
    };
    
    extern function select_constraint(input bit[1:0] sel);
    extern function new (input string name = "Packet");
    extern function Packet_generate();
    extern function void display(input string prefix="NOTE");
endclass:Packet

function Packet::select_constraint(input bit[1:0] sel);
    case(sel) 
        2'b00: begin
            this.load_store_group.constraint_mode(1);
            this.integer_group.constraint_mode(0);
            this.branch_jump_group.constraint_mode(0);
            this.all_instruction.constraint_mode(0);
        end
        2'b01: begin
            this.load_store_group.constraint_mode(0);
            this.integer_group.constraint_mode(1);
            this.branch_jump_group.constraint_mode(0);
            this.all_instruction.constraint_mode(0);
        end
        2'b10: begin
            this.load_store_group.constraint_mode(0);
            this.integer_group.constraint_mode(0);
            this.branch_jump_group.constraint_mode(1);
            this.all_instruction.constraint_mode(0);
        end
        2'b11: begin
            this.load_store_group.constraint_mode(0);
            this.integer_group.constraint_mode(0);
            this.branch_jump_group.constraint_mode(0);
            this.all_instruction.constraint_mode(1);
        end
    endcase
endfunction

function Packet::new (input string name);
    this.name = name;
endfunction: new

function Packet::Packet_generate();
    if (opcode == 7'b0010011) begin //I-type
        if ((funct3 == 3'b001 || funct3 == 3'b101)) begin
            instruction[31:25] = funct7;
            instruction[24:20] = imm[4:0];
            instruction[19:15] = rs1;
            instruction[14:12] = funct3;
            instruction[11:7]  = rd;
            instruction[6:0]   = opcode;  
        end 
        else begin
            instruction[31:20] = imm;
            instruction[19:15] = rs1;
            instruction[14:12] = funct3;
            instruction[11:7]  = rd;
            instruction[6:0]   = opcode;  
        end     
    end
    else if (opcode == 7'b0000011 || opcode == 7'b1100111) begin //Load, JALR
            instruction[31:20] = imm;
            instruction[19:15] = rs1;
            instruction[14:12] = funct3;
            instruction[11:7]  = rd;
            instruction[6:0]   = opcode;  
        end    
    else if (opcode == 7'b0110111 || 7'b0010111 || 7'b1101111) begin //LUI, AUIPC, JAL
            instruction[31:12] = imm_20;
            instruction[11:7]  = rd;
            instruction[6:0]   = opcode;
    end
    else if (opcode == 7'b1100011) begin //Branch
            instruction[31:25] = {imm[12],imm[10:5]};
            instruction[24:20] = rs2;
            instruction[19:15] = rs1;
            instruction[14:12] = funct3;
            instruction[11:7]  = {imm[4:1],imm[11]};
            instruction[6:0]   = opcode;
    end
    else if (opcode == 7'b0100011) begin //Store
            instruction[31:25] = imm[11:5];
            instruction[24:20] = rs2;
            instruction[19:15] = rs1;
            instruction[14:12] = funct3;
            instruction[11:7]  = imm[4:0];
            instruction[6:0]   = opcode;
    end
    else begin //R-Type
            instruction[31:25] = funct7;
            instruction[24:20] = rs2;
            instruction[19:15] = rs1;
            instruction[14:12] = funct3;
            instruction[11:7]  = rd;
            instruction[6:0]   = opcode;  
    end
endfunction: Packet_generate;

function void Packet::display(input string prefix);
    $display("%s", prefix);
    $display("funct7 = %b", funct7);
    $display("imm = %b", imm);
    $display("rs2 = %b", rs2);
    $display("funct3 = %b", funct3);
    $display("rs1 = %b", rs1);
    $display("rd = %b", rd);
    $display("opcode = %b", opcode);
    $display("instruction in binary = %b", instruction);
    $display("instruction in hex = %h", instruction);
endfunction 
