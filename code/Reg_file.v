module Reg_file(
    input clk,
    input rst,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [15:0] WriteData,
    input RegWrite,
    output [15:0] RD1,
    output [15:0] RD2
);

reg [15:0] registers [0:31];

assign RD1 = registers[rs1];
assign RD2 = registers[rs2];

integer i;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 16'b0;
    end
    else if (RegWrite) begin
        registers[rd] <= WriteData;
    end
end

endmodule