module RVC_decoder (
    input      [31:0] Instr,
    output reg [31:0] Instr_32
);

reg [17:0] imm;
reg [4:0] rs1_p, rs2_p, rd_p;
reg [4:0] rs1, rs2, rd;


always @(*) begin

    Instr_32 = 32'b0;
    imm     = 18'b0;

    if (Instr[1:0] == 2'b11) begin
        Instr_32 = Instr[31:0];
    end
    else begin

        case (Instr[1:0])
            2'b00: begin // Quadrant 0
                if (Instr[15:13] == 3'b000) begin
                    // C.ADDI4SPN - Add Immediate to Stack Pointer (SP)
                    imm[5:4] = Instr[12:11];
                    imm[9:6] = Instr[10:7];
                    imm[3]   = Instr[6];
                    imm[2]   = Instr[5];
                    rs1_p     = 5'b00010; // x2 (sp)
                    rd_p      = {2'b01, Instr[4:2]}; // x8-x15

                    Instr_32 = {
                        2'b00,                  // imm[11:10]
                        imm[9:6],               // imm[9:6]
                        imm[5:4],               // imm[5:4]
                        imm[3],                 // imm[3]
                        imm[2],                 // imm[2]
                        2'b00,                  // imm[1:0]
                        rs1_p,                   // rs1 = x2 (sp)
                        3'b000,                 // funct3 = ADDI
                        rd_p,                    // rd = x8-x15
                        7'b0010011              // opcode = ADDI
                    };
                end else if (Instr[15:13] == 3'b010) begin
                    //C.LW - Load Word
                    imm[5:3] = Instr[12:10];
                    imm[2]   = Instr[6];
                    imm[6]   = Instr[5];
                    rs1_p     = {2'b01, Instr[9:7]}; // x8-x15
                    rd_p      = {2'b01, Instr[4:2]}; // x8-x15

                    Instr_32 = {
                        5'b00000,               // imm[11:7]
                        imm[6],                 // imm[6]
                        imm[5:3],               // imm[5:3]
                        imm[2],                 // imm[2]
                        2'b00,                  // imm[1:0]
                        rs1_p,                   // rs1 = x8-x15
                        3'b010,                 // funct3 = LW
                        rd_p,                    // rd = x8-x15
                        7'b0000011              // opcode = LOAD
                    };
                end else if(Instr[15:13] == 3'b110) begin
                    //C.SW - Store Word
                    imm[5:3] = Instr[12:10];
                    imm[2]   = Instr[6];
                    imm[6]   = Instr[5];
                    rs1_p     = {2'b01, Instr[9:7]}; // x8-x15
                    rs2_p     = {2'b01, Instr[4:2]}; // x8-x15

                    Instr_32 = {
                        {5'b00000,imm[6],imm[5]},  // imm[11:5]
                        rs2_p,                      // rs2 = x8-x15
                        rs1_p,                      // rs1 = x8-x15
                        3'b010,                    // funct3 = SW
                        {imm[4:3], imm[2], 2'b00}, // imm[4:0]
                        7'b0100011
                    };
                end
            end
            2'b01: begin // Quadrant 1
                if(Instr[15:13] == 3'b000)begin
                    //C.ADDI - Add Immediate
                    imm[5]   = Instr[12];
                    imm[4:0] = Instr[6:2];
                    rs1_p     = Instr[11:7]; // x0-x31
                    rd_p      = Instr[11:7]; // x0-x31

                    Instr_32 = {
                        {6{imm[5]}},               // imm[11:6]
                        imm[5],                  // imm[5]
                        imm[4:0],                // imm[4:0]
                        rs1_p,                    // rs1 = x0-x31
                        3'b000,                  // funct3 = ADDI
                        rd_p,                     // rd = x0-x31
                        7'b0010011               // opcode = ADDI
                    };    
                end else if(Instr[15:13] == 3'b001) begin
                    //C.JAL - Jump and Link
                    imm[11]  = Instr[12];
                    imm[4]   = Instr[11];
                    imm[9:8] = Instr[10:9];
                    imm[10]  = Instr[8];
                    imm[6]   = Instr[7];
                    imm[7]   = Instr[6];
                    imm[3:1] = Instr[5:3];
                    imm[5]   = Instr[2];

                    Instr_32 = {
                        imm[11],                                      // imm[20]
                        {imm[10], imm[9:8], imm[7], imm[6],
                        imm[5], imm[4:1]},                           // imm[10:1]
                        imm[11],                                      // imm[11]
                        {8{imm[11]}},                                 // imm[19:12]
                        5'b00001,                                     // rd = x1
                        7'b1101111                                    // JAL
                    };
                end else if (Instr[15:13] == 3'b100) begin
                    imm[5]   = Instr[12];
                    imm[4:0] = Instr[6:2];
                    rs1_p     = {2'b01, Instr[9:7]}; // x8-x15
                    rd_p      = {2'b01, Instr[9:7]}; // x8-x15
                        if(Instr[11:10] == 2'b00)begin
                        //C.SRLI - Shift Left Logical Immediate
                        Instr_32 = {
                            6'b000000,               // imm[11:6]
                            imm[5],                  // imm[5]
                            imm[4:0],                // imm[4:0]
                            rs1_p,                    // rs1 = x8-x15
                            3'b101,                  // funct3 = SRLI
                            rd_p,                     // rd = x8-x15
                            7'b0010011               // opcode = SRLI
                        };   
                        end else if(Instr[11:10] == 2'b01)begin
                            //C.SRAI - Shift Right Arithmetic Immediate
                            Instr_32 = {
                                6'b010000,               // imm[11:6]
                                imm[5],                  // imm[5]
                                imm[4:0],                // imm[4:0]
                                rs1_p,                    // rs1 = x8-x15
                                3'b101,                  // funct3 = SRAI
                                rd_p,                     // rd = x8-x15
                                7'b0010011               // opcode = SRAI
                            };
                        end else if(Instr[11:10] == 2'b10)begin
                            //C.ANDI - AND Immediate
                            Instr_32 = {
                                {6{imm[5]}},               // imm[11:6]
                                imm[5],                  // imm[5]
                                imm[4:0],                // imm[4:0]
                                rs1_p,                    // rs1 = x8-x15
                                3'b111,                  // funct3 = ANDI
                                rd_p,                     // rd = x8-x15
                                7'b0010011               // opcode = ANDI
                            };
                        end else if(Instr[11:10] == 2'b11)begin
                            rs2_p = {2'b01, Instr[4:2]}; // x8-x15
                            rs1_p = {2'b01, Instr[9:7]}; // x8-x15
                            rd_p  = {2'b01, Instr[9:7]}; // x8-x15
                                if (Instr[12] == 1'b0) begin
                                    if(Instr[6:5] == 2'b00)begin
                                        //C.SUB - Subtract
                                        Instr_32 = {
                                            7'b0100000,             // funct7 = SUB
                                            rs2_p,                   // rs2 = x8-x15
                                            rs1_p,                   // rs1 = x8-x15
                                            3'b000,                 // funct3 = SUB
                                            rd_p,                    // rd = x8-x15
                                            7'b0110011              // opcode = R-type
                                        };
                                    end else if(Instr[6:5] == 2'b01)begin
                                        //C.XOR - XOR
                                        Instr_32 = {
                                            7'b0000000,             // funct7 = XOR
                                            rs2_p,                   // rs2 = x8-x15
                                            rs1_p,                   // rs1 = x8-x15
                                            3'b100,                 // funct3 = XOR
                                            rd_p,                    // rd = x8-x15
                                            7'b0110011              // opcode = R-type
                                        };
                                    end else if(Instr[6:5] == 2'b10)begin
                                        //C.OR - OR
                                        Instr_32 = {
                                            7'b0000000,             // funct7 = OR
                                            rs2_p,                   // rs2 = x8-x15
                                            rs1_p,                   // rs1 = x8-x15
                                            3'b110,                 // funct3 = OR
                                            rd_p,                    // rd = x8-x15
                                            7'b0110011              // opcode = R-type
                                        };
                                    end else if(Instr[6:5] == 2'b11)begin
                                        //C.AND - AND
                                        Instr_32 = {
                                            7'b0000000,             // funct7 = AND
                                            rs2_p,                   // rs2 = x8-x15
                                            rs1_p,                   // rs1 = x8-x15
                                            3'b111,                 // funct3 = AND
                                            rd_p,                    // rd = x8-x15
                                            7'b0110011              // opcode = R-type
                                        };
                                    end
                                end
                        end
                end else if (Instr[15:13] == 3'b011) begin
                    rs1 = Instr[11:7]; // x0-x31
                    rd  = Instr[11:7]; // x0-x31
                    if (rs1 == 5'b00010) begin
                        //C.ADDI16SP - Add Immediate to Stack Pointer (SP)
                        imm[9]   = Instr[12];
                        imm[8]   = Instr[4];
                        imm[7]   = Instr[3];
                        imm[6]   = Instr[5];
                        imm[5]   = Instr[2];
                        imm[4]   = Instr[6];
                        imm[3:0] = 4'b0000;

                        Instr_32 = {
                            {2{imm[9]}},       // imm[11:10]
                            imm[9:0],          // imm[9:0]
                            5'b00010,          // rs1 = x2
                            3'b000,            // funct3 = ADDI
                            5'b00010,          // rd = x2
                            7'b0010011          // opcode
                        };
                    end else begin
                        //C.LUI - Load Upper Immediate
                        imm[17:12] = {Instr[12], Instr[6:2]};

                        Instr_32 = {
                            {14{imm[12]}},      // imm[31:18]
                            imm[17:12],              // imm[17:12]
                            rd,                     // rd = x0-x31
                            7'b0110111                // opcode = LUI
                        };
                    end
                end else if (Instr[15:13] == 3'b110) begin
                    //C.BEQZ - Branch if Equal to Zero
                    imm[8]   = Instr[12];
                    imm[4:3] = Instr[11:10];
                    imm[7:6] = Instr[6:5];
                    imm[2:1] = Instr[4:3];
                    imm[5]   = Instr[2];
                    rs1_p     = {2'b01, Instr[9:7]}; // x8-x15

                    Instr_32 = {
                        imm[8],                         // imm[12]
                        {3{imm[8]}}, imm[7:5],          // imm[10:5]
                        5'b00000,                       // rs2 = x0
                        rs1_p,                          // rs1
                        3'b000,                         // BEQ
                        imm[4:1],                       // imm[4:1]
                        imm[8],                         // imm[11]
                        7'b1100011
                    };
                end else if (Instr[15:13] == 3'b111) begin
                    //C.BNEZ - Branch if Not Equal to Zero
                    imm[8]   = Instr[12];
                    imm[4:3] = Instr[11:10];
                    imm[7:6] = Instr[6:5];
                    imm[2:1] = Instr[4:3];
                    imm[5]   = Instr[2];
                    rs1_p     = {2'b01, Instr[9:7]}; // x8-x15

                    Instr_32 = {
                        imm[8],
                        {3{imm[8]}}, imm[7:5],
                        5'b00000,
                        rs1_p,
                        3'b001,
                        imm[4:1],
                        imm[8],
                        7'b1100011
                    };
                end
            end
            2'b10 :begin // Quadrant 2 

                if(Instr[15:13] == 3'b000) begin
                    //C.SLLI - Shift Left Logical Immediate
                    imm[5]   = Instr[12];
                    imm[4:0] = Instr[6:2];
                    rs1_p     = Instr[11:7]; // x0-x31
                    rd_p      = Instr[11:7]; // x0-x31

                    Instr_32 = {
                        6'b000000,               // imm[11:6]
                        imm[5],                  // imm[5]
                        imm[4:0],                // imm[4:0]
                        rs1_p,                    // rs1 = x0-x31
                        3'b001,                  // funct3 = SLLI
                        rd_p,                     // rd = x0-x31
                        7'b0010011               // opcode = SLLI
                    };
                end else if (Instr[15:13] == 3'b100) begin
                        if (Instr[12] == 1'b0 ) begin
                            if(Instr[6:2] == 5'b00000)begin
                            //C.JR - Jump Register
                            rs1_p = Instr[11:7]; // x0-x31
                            Instr_32 = {
                                12'b000000000000,       // imm[11:0]
                                rs1_p,                   // rs1 = x0-x31
                                3'b000,                 // funct3 = JALR
                                5'b00000,               // rd = x0
                                7'b1100111              // opcode = JALR
                            };
                        end else begin
                            //C.MV - Move
                            rs2_p = Instr[6:2]; // x0-x31
                            rd_p = Instr[11:7]; // x0-x31

                            Instr_32 = {
                                12'b000000000000,       // imm[11:0]
                                rs2_p,                   // rs2 = x0-x31
                                rd_p,                    // rd = x0-x31
                                3'b000,                 // funct3 = ADD
                                rd_p,                    // rd = x0-x31
                                7'b0110011              // opcode = R-type
                            };
                        end
                        end else if (Instr[12] == 1'b1) begin
                            if(Instr[6:2] == 5'b00000)begin
                                //C.JALR - Jump and Link Register
                                rs1_p = Instr[11:7]; // x0-x31
                                Instr_32 = {
                                    12'b000000000000,       // imm[11:0]
                                    rs1_p,                   // rs1 = x0-x31
                                    3'b000,                 // funct3 = JALR
                                    5'b00001,               // rd = x1
                                    7'b1100111              // opcode = JALR
                                };
                            end else begin
                                //C.ADD - Add
                                rs2_p = Instr[6:2]; // x0-x31
                                rd_p  = Instr[11:7]; // x0-x31

                                Instr_32 = {
                                    12'b000000000000,       // imm[11:0]
                                    rs2_p,                   // rs2 = x0-x31
                                    rd_p,                    // rd = x0-x31
                                    3'b000,                 // funct3 = ADD
                                    rd_p,                    // rd = x0-x31
                                    7'b0110011              // opcode = R-type
                                };
                            end
                        end
                end
            end 
            2'b11: begin // Quadrant 3
                // Reserved for future use
                Instr_32[31:0] = Instr[31:0]; // Pass through the instruction as is
            end
        endcase

    end

end

endmodule