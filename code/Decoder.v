module Decoder(
    input [15:0] Instr,
    output reg [4:0] rd,
    output reg [4:0] rs2,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ISCmv,
    output reg [2:0] ALUCtrl
);

always @(*) begin
    rd       = 5'b00000;
    rs2      = 5'b00000;
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    ALUCtrl  = 3'b000;

    if (Instr[15:12] == 4'b1001 &&
        Instr[1:0]   == 2'b10) begin // C.ADD

        rd       = Instr[11:7];
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUCtrl  = 3'b000;
        ISCmv    = 1'b0;
    end

    if(Instr[15:12] == 4'b1000  &&
        Instr[1:0]   == 2'b10) begin //C.MV

        rd       = Instr[11:7];
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUCtrl  = 3'b000;
        ISCmv    = 1'b1;
    end

end

endmodule