module Datapath(
    input clk,rst,
    input [2:0] ALUCtrl,
    input [4:0] rd,rs1,rs2,
    input [15:0] ImmExt,
    input RegWrite,
    input ALUSrc,UseSp,ISCmv,PCSrc,Jal,
    input MemWrite,MemtoReg,PCforJR,
    output reg [15:0] PC,
    output [15:0] ALUResult
);
 
wire [15:0] RD1,PCplus2,RD2,WriteData,ALU_A,ALU_B,MemReadData;
wire [4:0]  rs1_actual;

always@(posedge clk or negedge rst)begin
  if(!rst) PC <= 16'b0;
  else PC = PCNext;
end
 
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

Adder pcadd2(PC , 16'b10, PCplus2);
Adder pcaddbranch (PC, ImmExt, PCTarget);

 
assign rs1_actual = UseSp  ? 5'b00010 : rs1;
assign PCNext     = PCSrc  ? (PCforJR ? RD1:PCTarget) : PCPlus2; //pcmux
assign WriteData = Jal ? PCPlus2 : (MemtoReg ? MemReadData : ALUResult);
assign ALU_A      = ISCmv  ? 16'b0  : RD1;
assign ALU_B      = ALUSrc ? ImmExt : RD2;
 
endmodule