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
    output [15:0] ALUResult
);

wire [15:0] RD1;
wire [15:0] RD2;
wire [15:0] WriteData;
wire [15:0] ALU_A;
wire [15:0] ALU_B;

Reg_file reg_file(
    clk, rst,rd,
    rs2,rd,WriteData,
    RegWrite,RD1,RD2
);

ALU alu(
    ALU_A,ALU_B,
    ALUCtrl,ALUResult
);

assign ALU_B = ALUSrc ? ImmExt : RD2;
assign ALU_A = ISCmv ? 16'b0 : RD1;
assign WriteData = ALUResult;

endmodule