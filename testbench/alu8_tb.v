alu8_tb.v _ CODE:

`timescale 1ns/1ps

module alu8_tb;

reg [7:0] A;
reg [7:0] B;
reg [2:0] OP;

wire [7:0] Y;
wire Carry;
wire Zero;

integer pass_count;
integer fail_count;
integer i;
integer expected_value;

reg [7:0] expected_Y;
reg expected_Carry;

alu8 uut (
    .A(A),
    .B(B),
    .OP(OP),
    .Y(Y),
    .Carry(Carry),
    .Zero(Zero)
);

task check_result;
    input [7:0] expected_Y;
    input expected_Carry;
    input [7:0] expected_A;
    input [7:0] expected_B;
    input [2:0] expected_OP;

    begin
        #1;

        if ((Y === expected_Y) &&
            (Carry === expected_Carry) &&
            (Zero === (expected_Y == 8'b00000000))) begin

            $display("PASS: A=%h B=%h OP=%b -> Y=%h Carry=%b Zero=%b",
                     expected_A, expected_B, expected_OP,
                     Y, Carry, Zero);

            pass_count = pass_count + 1;
        end
        else begin

            $display("FAIL: A=%h B=%h OP=%b -> Expected Y=%h Carry=%b, Got Y=%h Carry=%b Zero=%b",
                     expected_A, expected_B, expected_OP,
                     expected_Y, expected_Carry,
                     Y, Carry, Zero);

            fail_count = fail_count + 1;
        end
    end
endtask

initial begin

    $dumpfile("alu8.vcd");
    $dumpvars(0, alu8_tb);

    pass_count = 0;
    fail_count = 0;

    // ADD
    A = 8'd25;
    B = 8'd17;
    OP = 3'b000;
    check_result(8'd42, 1'b0, A, B, OP);
    #9;

    // SUB
    A = 8'd50;
    B = 8'd20;
    OP = 3'b001;
    check_result(8'd30, 1'b0, A, B, OP);
    #9;

    // AND
    A = 8'hF0;
    B = 8'h0F;
    OP = 3'b010;
    check_result(8'h00, 1'b0, A, B, OP);
    #9;

    // OR
    A = 8'hF0;
    B = 8'h0F;
    OP = 3'b011;
    check_result(8'hFF, 1'b0, A, B, OP);
    #9;

    // XOR
    A = 8'hF0;
    B = 8'h0F;
    OP = 3'b100;
    check_result(8'hFF, 1'b0, A, B, OP);
    #9;

    // NOT A
    A = 8'h55;
    B = 8'h00;
    OP = 3'b101;
    check_result(8'hAA, 1'b0, A, B, OP);
    #9;

    // Increment
    A = 8'd100;
    B = 8'd0;
    OP = 3'b110;
    check_result(8'd101, 1'b0, A, B, OP);
    #9;

    // Decrement
    A = 8'd100;
    B = 8'd0;
    OP = 3'b111;
    check_result(8'd99, 1'b0, A, B, OP);
    #9;

    // Edge case: 255 + 1
    A = 8'hFF;
    B = 8'h01;
    OP = 3'b000;
    check_result(8'h00, 1'b1, A, B, OP);
    #9;

    // Edge case: 100 - 100 = 0
    A = 8'd100;
    B = 8'd100;
    OP = 3'b001;
    check_result(8'h00, 1'b0, A, B, OP);
    #9;

    // Edge case: 0 - 1
    A = 8'h00;
    B = 8'h01;
    OP = 3'b001;
    check_result(8'hFF, 1'b1, A, B, OP);
    #9;

    // Edge case: 255 + 1 using increment
    A = 8'hFF;
    B = 8'h00;
    OP = 3'b110;
    check_result(8'h00, 1'b1, A, B, OP);
    #9;

    // Edge case: 0 - 1 using decrement
    A = 8'h00;
    B = 8'h00;
    OP = 3'b111;
    check_result(8'hFF, 1'b1, A, B, OP);
    #9;

    // Randomized verification
    $display("");
    $display("Starting 100 randomized tests...");

    for (i = 0; i < 100; i = i + 1) begin

        A = $urandom_range(0, 255);
        B = $urandom_range(0, 255);
        OP = $urandom_range(0, 7);

        expected_Y = 8'b00000000;
        expected_Carry = 1'b0;
        expected_value = 0;

        case (OP)

            3'b000: begin
                expected_value = A + B;
                expected_Y = expected_value[7:0];
                expected_Carry = (expected_value > 255);
            end

            3'b001: begin
                expected_Y = A - B;
                expected_Carry = (A < B);
            end

            3'b010: begin
                expected_Y = A & B;
            end

            3'b011: begin
                expected_Y = A | B;
            end

            3'b100: begin
                expected_Y = A ^ B;
            end

            3'b101: begin
                expected_Y = ~A;
            end

            3'b110: begin
                expected_Y = A + 1;
                expected_Carry = (A == 255);
            end

            3'b111: begin
                expected_Y = A - 1;
                expected_Carry = (A == 0);
            end

        endcase

        check_result(expected_Y, expected_Carry, A, B, OP);
        #9;
    end

    $display("");
    $display("==============================");
    $display("       8-BIT ALU SUMMARY");
    $display("==============================");
    $display("Tests Passed : %0d", pass_count);
    $display("Tests Failed : %0d", fail_count);

    if (fail_count == 0)
        $display("ALL TESTS PASSED!");
    else
        $display("SOME TESTS FAILED!");

    $display("==============================");

    $finish;
end

endmodule
