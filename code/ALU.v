module ALU(
    input [15:0] A,
    input [15:0] B,
    input [2:0] ALUCtrl,

    output reg [15:0] ALUResult
);

always @(*) begin

    case(ALUCtrl)

        3'b000: ALUResult = A + B;   // C.ADD , C.MV
        3'b001: ALUResult = A - B;   // C.SUB

        default: ALUResult = 16'b0;
    endcase
end
endmodule