module Datapath(
    input clk,rst,
    input [2:0] ALUCtrl,
    input [4:0] rd,
    input [4:0] rs2,
    input RegWrite,
    input ALUSrc,

    output [15:0] ALUResult
);

wire [15:0] RD1;
wire [15:0] RD2;
wire [15:0] WriteData;

Reg_file reg_file(
    clk,rst,rd,rs2, rd,
    WriteData,RegWrite,
    RD1,RD2
);

ALU alu(
    RD1,RD2,ALUCtrl,
    ALUResult
);

assign WriteData = ALUResult;

endmodule 