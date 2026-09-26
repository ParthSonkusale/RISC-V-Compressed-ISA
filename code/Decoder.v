module Decoder(
    input  [15:0] Instr,
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg       RegWrite,
    output reg       ALUSrc,
    output reg       ISCmv,
    output reg [15:0] ImmExt,
    output reg       UseSp,
    output reg [2:0] ALUCtrl,
    output reg       MemWrite,
    output reg       MemtoReg
);
 
always @(*) begin
    // ---- safe defaults every cycle ----
    rd       = 5'b00000;
    rs1      = 5'b00000;
    rs2      = 5'b00000;
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    ISCmv    = 1'b0;
    ALUCtrl  = 3'b000;
    ImmExt   = 16'b0;
    UseSp    = 1'b0;
    MemWrite = 1'b0;
    MemtoReg = 1'b0;
 
    if (Instr[15:12] == 4'b1001 &&
        Instr[1:0]   == 2'b10) begin // C.ADD  (CR format)
 
        rd       = Instr[11:7];
        rs1      = Instr[11:7];   // CR format: rd/rs1 share the same field
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
        ISCmv    = 1'b0;
 
    end
 
    else if (Instr[15:12] == 4'b1000 &&
             Instr[1:0]   == 2'b10) begin // C.MV  (CR format)
 
        rd       = Instr[11:7];
        rs1      = 5'b00000;      // unused: ISCmv forces ALU_A = 0
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUCtrl  = 3'b000;
        UseSp    = 1'b0;
        ISCmv    = 1'b1;
 
    end
 
    else if (Instr[15:10] == 6'b100011 &&
             Instr[6:5]   == 2'b00 &&
             Instr[1:0]   == 2'b01) begin // C.SUB
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};  // rd' and rs1' are the same field
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b001;
 
    end
 
    else if (Instr[15:10] == 6'b100011 &&
             Instr[6:5]   == 2'b01 &&
             Instr[1:0]   == 2'b01) begin // C.XOR
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        UseSp    = 1'b0;
        ISCmv    = 1'b0;
        ALUCtrl  = 3'b010;
 
    end
 
    else if(Instr[15:10] == 6'b100011 &&
        Instr[6:5]   == 2'b10 &&
        Instr[1:0]   == 2'b01) begin // C.OR
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b011;
 
    end
 
    else if(Instr[15:10] == 6'b100011 &&
        Instr[6:5]   == 2'b11 &&
        Instr[1:0]   == 2'b01) begin // C.AND
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b100;
 
    end
 
    else if(Instr[15:13] == 3'b010 &&
        Instr[1:0]   == 2'b01) begin // C.LI
 
        rd       = Instr[11:7];
        rs1      = 5'b00000;      // unused: ISCmv forces ALU_A = 0 (acts as x0)
        rs2      = 5'b00000;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b1;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
 
        ImmExt = {{10{Instr[12]}}, Instr[12], Instr[6:2]};
    end
 
    else if(Instr[15:13] == 3'b000 &&
        Instr[1:0]   == 2'b01) begin // C.ADDI
 
        rd       = Instr[11:7];
        rs1      = Instr[11:7];   // addi rd, rd, imm
        rs2      = 5'b00000;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
 
        ImmExt = {{10{Instr[12]}}, Instr[12], Instr[6:2]};
 
    end
 
    else if(Instr[15:13] == 3'b011 &&
            Instr[11:7] == 5'b00010 &&
            Instr[1:0]   == 2'b01) begin // C.ADDI16SP
 
        rd       = 5'b00010;      // x2 (sp)
        rs1      = 5'b00010;      // addi x2, x2, imm
        rs2      = 5'b00000;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
 
        ImmExt = {{7{Instr[12]}},
                  Instr[4:3],
                  Instr[5],
                  Instr[2],
                  Instr[6],
                  4'b0000};
    end
 
    else if(Instr[15:13] == 3'b011 &&
            Instr[11:7] != 5'b00000 &&
            Instr[11:7] != 5'b00010 &&
            Instr[1:0]   == 2'b01) begin // C.LUI
 
        rd       = Instr[11:7];
        rs1      = 5'b00000;      // unused: ISCmv forces ALU_A = 0
        rs2      = 5'b00000;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b1;          // was 1'b0 - LUI must not add a stale rs1 value
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
 
        ImmExt = {6'b000000,
                  Instr[12],
                  Instr[6:2],
                  4'b0000};
    end
 
    else if(Instr[15:13] == 3'b010 &&
            Instr[1:0]   == 2'b00) begin // C.LW  (CL format)
 
        rd       = {2'b01, Instr[4:2]};   // dest register  (rd')
        rs1      = {2'b01, Instr[9:7]};   // base register  (rs1') - was missing
        rs2      = 5'b00000;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;                // address = base + imm
        MemtoReg = 1'b1;                  // writeback comes from memory, not ALU
 
        ImmExt = {9'b0, Instr[5], Instr[12:10], Instr[6], 2'b0};
    end
 
    else if(Instr[15:13] == 3'b110 &&
            Instr[1:0]   == 2'b00) begin // C.SW  (CS format)
 
        rd       = 5'b00000;              // no writeback
        rs1      = {2'b01, Instr[9:7]};   // base register (rs1') - was missing
        rs2      = {2'b01, Instr[4:2]};   // data to store
        RegWrite = 1'b0;                  // was incorrectly 1'b1
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;                // address = base + imm
        MemWrite = 1'b1;                  // was missing entirely
 
        ImmExt = {9'b0, Instr[5], Instr[12:10], Instr[6], 2'b0};
    end
 
end
endmodule