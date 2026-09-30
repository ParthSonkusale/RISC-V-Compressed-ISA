module ALU(
    input  [15:0] A,
    input  [15:0] B,
    input  [2:0]  ALUCtrl,
 
    output reg [15:0] ALUResult
);
 
always @(*) begin
    case(ALUCtrl)
        3'b000: ALUResult = A + B;   // C.ADD / C.ADDI / C.LI / C.LUI / C.LW / C.SW address
        3'b001: ALUResult = A - B;   // C.SUB
        3'b010: ALUResult = A ^ B;   // C.XOR
        3'b011: ALUResult = A | B;   // C.OR
        3'b100: ALUResult = A & B;   // C.AND
        3'b111: ALUResult = A >>B;   //C.SRLI (logical Right shift)
        3'b101: ALUResult = $signed(A) >>>B;   //C.SRAI(Arithmatic Right shift)
        3'b110: ALUResult = A <<B;   //C.SLLI(logical left shift)
        default: ALUResult = 16'b0;
    endcase
end
endmodule