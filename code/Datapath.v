module Datapath(
    input clk,
    input rst,
    input [2:0] ALUCtrl,
    input [4:0] rd,
    input [4:0] rs1,
    input [4:0] rs2,
    input RegWrite,
    input ALUSrc,
    input ISCmv,
    input [15:0] ImmExt,
    input UseSp,
    input MemWrite,
    input MemtoReg,
    output [15:0] ALUResult
);
 
wire [15:0] RD1;
wire [15:0] RD2;
wire [15:0] WriteData;
wire [15:0] ALU_A;
wire [15:0] ALU_B;
wire [4:0]  rs1_actual;
wire [15:0] MemReadData;
 
Reg_file reg_file(
    clk, rst, rs1_actual,
    rs2, rd, WriteData,
    RegWrite, RD1, RD2
);
 
ALU alu(
    ALU_A, ALU_B,
    ALUCtrl, ALUResult
);
 
Data_Mem data_mem(
    clk, MemWrite,
    ALUResult, RD2,
    MemReadData
);
 
assign rs1_actual = UseSp ? 5'b00010 : rs1;
 
assign ALU_A      = ISCmv ? 16'b0 : RD1;
assign ALU_B      = ALUSrc ? ImmExt : RD2;
assign WriteData  = MemtoReg ? MemReadData : ALUResult;
 
endmodule