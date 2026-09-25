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

// Clock: 10 ns period
always #5 clk = ~clk;


initial begin

    // --------------------------------
    // INITIALIZATION
    // --------------------------------
    clk   = 0;
    rst   = 1;
    Instr = 16'h0000;

    #10;
    rst = 0;


    // ==================================================
    // TEST 1 : C.ADD x3, x4
    // Encoding = 16'h9192
    // x3 = x3 + x4
    // ==================================================

    dut.datapath.reg_file.registers[3] = 16'd10;  // x3 = 10
    dut.datapath.reg_file.registers[4] = 16'd20;  // x4 = 20

    Instr = 16'h9192;  // C.ADD x3, x4

    #10;

    $display("========================================");
    $display("TEST 1 : C.ADD x3, x4");
    $display("========================================");

    $display("x3 = %d", dut.datapath.reg_file.registers[3]);
    $display("x4 = %d", dut.datapath.reg_file.registers[4]);
    $display("RD1 = %d", dut.datapath.RD1);
    $display("RD2 = %d", dut.datapath.RD2);
    $display("ALU_A = %d", dut.datapath.ALU_A);
    $display("ALUResult = %d", dut.datapath.ALUResult);
    $display("Result = %d", Result);

    if (dut.datapath.reg_file.registers[3] == 16'd30)
        $display("C.ADD PASS");
    else
        $display("C.ADD FAIL");


    // ==================================================
    // TEST 2 : C.MV x5, x4
    // Encoding = 16'h8292
    // x5 = x4
    // ==================================================

    dut.datapath.reg_file.registers[4] = 16'd25;  // x4 = 25
    dut.datapath.reg_file.registers[5] = 16'd0;   // x5 = 0

    Instr = 16'h8292;  // C.MV x5, x4

    #10;

    $display("========================================");
    $display("TEST 2 : C.MV x5, x4");
    $display("========================================");

    $display("x4 = %d", dut.datapath.reg_file.registers[4]);
    $display("x5 = %d", dut.datapath.reg_file.registers[5]);
    $display("RD1 = %d", dut.datapath.RD1);
    $display("RD2 = %d", dut.datapath.RD2);
    $display("ALU_A = %d", dut.datapath.ALU_A);
    $display("ALUResult = %d", dut.datapath.ALUResult);
    $display("Result = %d", Result);

    if (dut.datapath.reg_file.registers[5] == 16'd25)
        $display("C.MV PASS");
    else
        $display("C.MV FAIL");

        // ==================================================
        // TEST 3 : C.SUB x9, x10
        // Encoding = 16'h8C89
        // x9 = x9 - x10
        // ==================================================

        dut.datapath.reg_file.registers[9]  = 16'd50;  // x9 = 50
        dut.datapath.reg_file.registers[10] = 16'd20;  // x10 = 20

        Instr = 16'h8C89;  // C.SUB x9, x10

        #10;

        $display("========================================");
        $display("TEST 3 : C.SUB x9, x10");
        $display("========================================");

        $display("x9 = %d", dut.datapath.reg_file.registers[9]);
        $display("x10 = %d", dut.datapath.reg_file.registers[10]);
        $display("RD1 = %d", dut.datapath.RD1);
        $display("RD2 = %d", dut.datapath.RD2);
        $display("ALU_A = %d", dut.datapath.ALU_A);
        $display("ALUResult = %d", dut.datapath.ALUResult);
        $display("Result = %d", Result);

        if (dut.datapath.reg_file.registers[9] == 16'd30)
            $display("C.SUB PASS");
        else
            $display("C.SUB FAIL");

        // ==================================================
        // TEST 4 : C.XOR x9, x10
        // ==================================================

        dut.datapath.reg_file.registers[9]  = 16'h000F;
        dut.datapath.reg_file.registers[10] = 16'h0033;

        Instr = 16'h8CA9;  // C.XOR x9, x10

        #10;

        $display("========================================");
        $display("TEST 4 : C.XOR x9, x10");
        $display("========================================");

        $display("x9 = %h", dut.datapath.reg_file.registers[9]);
        $display("x10 = %h", dut.datapath.reg_file.registers[10]);
        $display("RD1 = %h", dut.datapath.RD1);
        $display("RD2 = %h", dut.datapath.RD2);
        $display("ALUResult = %h", dut.datapath.ALUResult);
        $display("Result = %h", Result);

        if (dut.datapath.reg_file.registers[9] == 16'h003C)
            $display("C.XOR PASS");
        else
            $display("C.XOR FAIL");

        // ==================================================
        // TEST 5 : C.OR x9, x10
        // Encoding = 16'h8CC9
        // x9 = x9 | x10
        // ==================================================

        dut.datapath.reg_file.registers[9]  = 16'h000F;
        dut.datapath.reg_file.registers[10] = 16'h0033;

        Instr = 16'h8CC9;  // C.OR x9, x10

        #10;

        $display("========================================");
        $display("TEST 5 : C.OR x9, x10");
        $display("========================================");

        $display("x9 = %h", dut.datapath.reg_file.registers[9]);
        $display("x10 = %h", dut.datapath.reg_file.registers[10]);
        $display("RD1 = %h", dut.datapath.RD1);
        $display("RD2 = %h", dut.datapath.RD2);
        $display("ALUResult = %h", dut.datapath.ALUResult);
        $display("Result = %h", Result);

        if (dut.datapath.reg_file.registers[9] == 16'h003F)
            $display("C.OR PASS");
        else
            $display("C.OR FAIL");

        // ==================================================
        // TEST 6 : C.AND x9, x10
        // Encoding = 16'h8CE9
        // x9 = x9 & x10
        // ==================================================

        dut.datapath.reg_file.registers[9]  = 16'h000F;
        dut.datapath.reg_file.registers[10] = 16'h0033;

        Instr = 16'h8CE9;  // C.AND x9, x10

        #10;

        $display("========================================");
        $display("TEST 6 : C.AND x9, x10");
        $display("========================================");

        $display("x9 = %h", dut.datapath.reg_file.registers[9]);
        $display("x10 = %h", dut.datapath.reg_file.registers[10]);
        $display("RD1 = %h", dut.datapath.RD1);
        $display("RD2 = %h", dut.datapath.RD2);
        $display("ALUResult = %h", dut.datapath.ALUResult);
        $display("Result = %h", Result);

        if (dut.datapath.reg_file.registers[9] == 16'h0003)
            $display("C.AND PASS");
        else
            $display("C.AND FAIL");    

        // ==================================================
        // TEST 7 : C.LI x6, 10
        // Encoding = 16'h4511
        // x6 = 10
        // ==================================================

        dut.datapath.reg_file.registers[6] = 16'd0;

        Instr = 16'h4329;

        #10;

        $display("========================================");
        $display("TEST 7 : C.LI x6, 10");
        $display("========================================");

        $display("x6 = %d", dut.datapath.reg_file.registers[6]);
        $display("ImmExt = %d", dut.datapath.ImmExt);
        $display("ALUResult = %d", dut.datapath.ALUResult);
        $display("Result = %d", Result);
        $display("Instr     = %h", Instr);
        if (dut.datapath.reg_file.registers[6] == 16'd10)
            $display("C.LI PASS");
        else
            $display("C.LI FAIL");

        // TEST 8 : C.ADDI x6, 10
        dut.datapath.reg_file.registers[6] = 16'd20;
        Instr = 16'h0329;
        #10;

        if (dut.datapath.reg_file.registers[6] == 16'd30)
            $display("C.ADDI PASS");
        else
            $display("C.ADDI FAIL");

        // TEST : C.ADDI16SP
        dut.datapath.reg_file.registers[2] = 16'd100;

        // C.ADDI16SP x2, 16
        Instr = 16'h6141;

        #10;

        if (dut.datapath.reg_file.registers[2] == 16'd116)
            $display("C.ADDI16SP PASS");
        else
            $display("C.ADDI16SP FAIL");

        $display("x2 = %d", dut.datapath.reg_file.registers[2]);
        $display("ImmExt = %d", dut.decoder.ImmExt);

    // --------------------------------
    // END SIMULATION
    // --------------------------------

    #10;
    $display("========================================");
    $display("ALL TESTS COMPLETED");
    $display("========================================");

    $stop;

end

endmodule