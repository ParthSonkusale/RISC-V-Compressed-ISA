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
    output reg       MemtoReg,
    output reg       Jal,
    output reg       PCSrc
);
 
always @(*) begin
    // ---- safe defaults every cycle ----
    rd       = 5'b0;
    rs1      = 5'b0;
    rs2      = 5'b0;
    RegWrite = 1'b0;
    ALUSrc   = 1'b0;
    ISCmv    = 1'b0;
    ALUCtrl  = 3'b000;
    ImmExt   = 16'b0;
    UseSp    = 1'b0;
    MemWrite = 1'b0;
    MemtoReg = 1'b0;
 
    if (Instr[15:12] == 4'b1001 &&   // C.ADD  (CR format)
        Instr[1:0]   == 2'b10) begin
 
        rd       = Instr[11:7];
        rs1      = Instr[11:7];   // CR format: rd/rs1 share the same field
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
        ISCmv    = 1'b0;
 
    end
 
    else if (Instr[15:12] == 4'b1000 &&  // C.MV  (CR format)
             Instr[1:0]   == 2'b10) begin 
 
        rd       = Instr[11:7];
        rs1      = 5'b0;      // unused: ISCmv forces ALU_A = 0
        rs2      = Instr[6:2];
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ALUCtrl  = 3'b000;
        UseSp    = 1'b0;
        ISCmv    = 1'b1;
 
    end
 
    else if (Instr[15:10] == 6'b100011 &&  // C.SUB
             Instr[6:5]   == 2'b00 &&
             Instr[1:0]   == 2'b01) begin 
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};  // rd' and rs1' are the same field
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b001;
 
    end
 
    else if (Instr[15:10] == 6'b100011 && // C.XOR
             Instr[6:5]   == 2'b01 &&
             Instr[1:0]   == 2'b01) begin 
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        UseSp    = 1'b0;
        ISCmv    = 1'b0;
        ALUCtrl  = 3'b010;
 
    end
 
    else if(Instr[15:10] == 6'b100011 && // C.OR
        Instr[6:5]   == 2'b10 &&
        Instr[1:0]   == 2'b01) begin 
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b011;
 
    end
 
    else if(Instr[15:10] == 6'b100011 && // C.AND
        Instr[6:5]   == 2'b11 &&
        Instr[1:0]   == 2'b01) begin 
 
        rd       = {2'b01, Instr[9:7]};
        rs1      = {2'b01, Instr[9:7]};
        rs2      = {2'b01, Instr[4:2]};
        RegWrite = 1'b1;
        ALUSrc   = 1'b0;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b100;
 
    end
 
    else if(Instr[15:13] == 3'b010 && // C.LI
        Instr[1:0]   == 2'b01) begin 
 
        rd       = Instr[11:7];
        rs1      = 5'b0;      // unused: ISCmv forces ALU_A = 0 (acts as x0)
        rs2      = 5'b0;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b1;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
 
        ImmExt = {{10{Instr[12]}}, Instr[12], Instr[6:2]};
    end
 
    else if(Instr[15:13] == 3'b000 &&  // C.ADDI
        Instr[1:0]   == 2'b01) begin
 
        rd       = Instr[11:7];
        rs1      = Instr[11:7];   // addi rd, rd, imm
        rs2      = 5'b0;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;
 
        ImmExt = {{10{Instr[12]}}, Instr[12], Instr[6:2]};
 
    end
 
    else if(Instr[15:13] == 3'b011 &&  // C.ADDI16SP
            Instr[11:7] == 5'b00010 &&
            Instr[1:0]   == 2'b01) begin 
 
        rd       = 5'b00010;      // x2 (sp)
        rs1      = 5'b00010;      // addi x2, x2, imm
        rs2      = 5'b0;
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
 
    else if(Instr[15:13] == 3'b011 &&  // C.LUI
            Instr[11:7] != 5'b0 &&
            Instr[11:7] != 5'b00010 &&
            Instr[1:0]   == 2'b01) begin
 
        rd       = Instr[11:7];
        rs1      = 5'b0;      // unused: ISCmv forces ALU_A = 0
        rs2      = 5'b0;
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
 
    else if(Instr[15:13] == 3'b010 &&  // C.LW  (CL format)
            Instr[1:0]   == 2'b00) begin 
 
        rd       = {2'b01, Instr[4:2]};   // dest register  (rd')
        rs1      = {2'b01, Instr[9:7]};   // base register  (rs1') - was missing
        rs2      = 5'b0;
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;                // address = base + imm
        MemtoReg = 1'b1;                  // writeback comes from memory, not ALU
 
        ImmExt = {9'b0, Instr[5], Instr[12:10], Instr[6], 2'b0};
    end
 
    else if(Instr[15:13] == 3'b110 &&  // C.SW  (CS format)
            Instr[1:0]   == 2'b00) begin 
 
        rd       = 5'b0;              // no writeback
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

    else if(Instr[15:13] == 3'b000 &&  //C.NOP
            Instr[12:2]  == 11'b0  &&
            Instr[1:0]   == 2'b10) begin 

        rd       = 5'b0;              
        rs1      = 5'b0;   
        rs2      = 5'b0;   
        RegWrite = 1'b1;
        ALUSrc   = 1'b1;
        ISCmv    = 1'b0;
        UseSp    = 1'b0;
        ALUCtrl  = 3'b000;              
        ImmExt   = 16'b0;

    end

    else if(Instr[15:13] == 001 &&  //C.JAL
            Instr[1:0]   == 01)begin 
            rd = 5'b0;
            rs1 = 5'b0;
            rs2 = 5'b0;
            RegWrite = 1'b1;
            Jal = 1'b1;
            PCSrc = 1'b1;
            ImmExt = {{5{Instr[12]}}, Instr[8], Instr[10:9], Instr[6], Instr[7], Instr[2], Instr[11], Instr[5:3], 1'b0};
    end


 
end
endmodule