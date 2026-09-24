module Decoder(
    input [15:0] Instr,
    output reg [4:0] rd,
    output reg [4:0] rs2,
    output reg RegWrite,
    output reg ALUSrc,
    output reg ISCmv,
    output reg [15:0] ImmExt,
    output reg [2:0] ALUCtrl
);

always @(*) begin
    rd       = 5'b00000;
    rs2      = 5'b00000;
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    ISCmv    = 1'b0;       
    ALUCtrl  = 3'b000;
    ImmExt   = 16'b0;

    if (Instr[15:12] == 4'b1001 &&
        Instr[1:0]   == 2'b10) begin // C.ADD

        rd       = Instr[11:7];
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUCtrl  = 3'b000;
        ISCmv    = 1'b0;
    end

    else if (Instr[15:12] == 4'b1000 &&
             Instr[1:0]   == 2'b10) begin // C.MV

        rd       = Instr[11:7];
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUCtrl  = 3'b000;
        ISCmv    = 1'b1;
    end

    else if (Instr[15:10] == 6'b100011 &&
             Instr[6:5]   == 2'b00 &&
             Instr[1:0]   == 2'b01) begin // C.SUB

        rd       = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        ALUCtrl  = 3'b001;
    end

    else if (Instr[15:10] == 6'b100011 &&
             Instr[6:5]   == 2'b01 &&
             Instr[1:0]   == 2'b01) begin // C.XOR

        rd       = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        ALUCtrl  = 3'b010;
    end

    else if(Instr[15:10] == 6'b100011 &&
        Instr[6:5]   == 2'b10 &&
        Instr[1:0]   == 2'b01) begin // C.OR

    rd       = {2'b01, Instr[9:7]};
    rs2      = {2'b01, Instr[4:2]};
    RegWrite = 1'b1;
    ALUSrc   = 1'b0;
    ISCmv    = 1'b0;
    ALUCtrl  = 3'b011;
    end

    else if(Instr[15:10] == 6'b100011 &&
        Instr[6:5]   == 2'b11 &&
        Instr[1:0]   == 2'b01) begin // C.AND

    rd       = {2'b01, Instr[9:7]};
    rs2      = {2'b01, Instr[4:2]};
    RegWrite = 1'b1;
    ALUSrc   = 1'b0;
    ISCmv    = 1'b0;
    ALUCtrl  = 3'b100;
    end

    else if(Instr[15:13] == 3'b010 &&
        Instr[1:0]   == 2'b01) begin // C.LI

    rd       = Instr[11:7];
    rs2      = 5'b00000;
    RegWrite = 1'b1;
    ALUSrc   = 1'b1;
    ISCmv    = 1'b1;
    ALUCtrl  = 3'b000;

    ImmExt = {{10{Instr[12]}}, Instr[12], Instr[6:2]};
    end

end

endmodule