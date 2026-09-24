module RVC_CPU(
    input clk,
    input rst,
    input [15:0] Instr,

    output [15:0] Result
);

wire [4:0] rd;
wire [4:0] rs2;
wire RegWrite;
wire ALUSrc;
wire [2:0] ALUCtrl;
wire [15:0] ImmExt;

Datapath datapath(
    clk,rst,ALUCtrl,rd,rs2,RegWrite,ALUSrc,
    ISCmv,ImmExt,Result
);

Decoder decoder(
    Instr,rd,rs2,RegWrite,ALUSrc,ISCmv,ImmExt,ALUCtrl
);


endmodule