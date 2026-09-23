`timescale 1ns/1ps

module RVC_CPU_tb;

reg clk;
reg rst;
reg [15:0] Instr;

wire [15:0] Result;

RVC_CPU dut (
    .clk(clk),
    .rst(rst),
    .Instr(Instr),
    .Result(Result)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    // Initial values
    clk  = 0;
    rst  = 1;
    Instr = 16'h0000;

    // Reset
    #10;
    rst = 0;

    // Initialize registers for testing
    dut.datapath.reg_file.registers[3] = 16'd10;  // x3 = 10
    dut.datapath.reg_file.registers[4] = 16'd20;  // x4 = 20

    // C.ADD x3, x4
    Instr = 16'h9192;

    // Wait for one clock
    #10;

    // Display result
    $display("x3 = %d", dut.datapath.reg_file.registers[3]);
    $display("Result = %d", Result);

    #10;

    $stop;
end

endmodule