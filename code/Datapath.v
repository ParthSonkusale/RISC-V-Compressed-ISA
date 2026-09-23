module Datapath(
    input clk,
    input rst,
    input [2:0] ALUCtrl,
    input [4:0] rd,
    input [4:0] rs2,
    input RegWrite,
    input ALUSrc,
    input ISCmv,

    output [15:0] ALUResult
);

wire [15:0] RD1;
wire [15:0] RD2;
wire [15:0] WriteData;
wire [15:0] ALU_A;

assign ALU_A = ISCmv ? 16'b0 : RD1;
assign WriteData = ALUResult;

Reg_file reg_file(
    clk,
    rst,
    rd,
    rs2,
    rd,
    WriteData,
    RegWrite,
    RD1,
    RD2
);

ALU alu(
    ALU_A,
    RD2,
    ALUCtrl,
    ALUResult
);

endmodule