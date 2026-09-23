module RVC_CPU(
        input clk,
    input rst,
    input [15:0] Instr,

    output [15:0] ALUResult
);

wire [4:0] rd;
wire [4:0] rs2;
wire RegWrite;
wire ALUSrc;
wire [2:0] ALUCtrl;

Datapath datapath(
    clk,rst,ALUCtrl,rd,rs2,RegWrite,ALUSrc,
    ALUResult
);

Decoder decoder(
    Instr,rd,rs2,RegWrite,ALUSrc,ALUCtrl
);