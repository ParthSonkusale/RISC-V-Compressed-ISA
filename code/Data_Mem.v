module Data_Mem(
    input clk,
    input MemWrite,
    input [15:0] Addr,
    input [15:0] WriteData,
    output [15:0] ReadData
);
 
    reg [15:0] mem [0:255];   // 256 x 16-bit words - resize as needed
 
    assign ReadData = mem[Addr[8:1]];
 
    always @(posedge clk) begin
        if (MemWrite)
            mem[Addr[8:1]] <= WriteData;
    end
 
endmodule