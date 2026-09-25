module Datapath(
    input clk,
    input rst,
    input [2:0] ALUCtrl,
    input [4:0] rd,
    input [4:0] rs2,
    input RegWrite,
    input ALUSrc,
    input ISCmv,
    input [15:0] ImmExt,
    input UseSp,
    output [15:0] ALUResult
);

wire [15:0] RD1;
wire [15:0] RD2;
wire [15:0] WriteData;
wire [15:0] ALU_A;
wire [15:0] ALU_B;
wire [4:0] rs1;

Reg_file reg_file(
    clk, rst,rs1,
    rs2,rd,WriteData,
    RegWrite,RD1,RD2
);

ALU alu(
    ALU_A,ALU_B,
    ALUCtrl,ALUResult
);

assign rs1 = UseSp ? 5'b00010 : rd; // Use x2 (sp) if UseSp is high, else use rd
assign ALU_B = ALUSrc ? ImmExt : RD2;
assign ALU_A = ISCmv ? 16'b0 : RD1;
assign WriteData = ALUResult;

endmodule