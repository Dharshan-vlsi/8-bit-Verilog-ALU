alu8.v_CODE:

`timescale 1ns/1ps
module alu8(
    input [7:0] A,
    input [7:0] B,
    input [2:0] OP,
    output reg [7:0] Y,
    output reg Carry,
    output Zero
);

always @(*) begin
    Y = 8'b00000000;
    Carry = 1'b0;

    case (OP)
        // Addition
        3'b000: begin
            {Carry, Y} = A + B;
        end

        // Subtraction
        3'b001: begin
            Y = A - B;
            Carry = (A < B);
        end

        // AND
        3'b010: begin
            Y = A & B;
        end

        // OR
        3'b011: begin
            Y = A | B;
        end

        // XOR
        3'b100: begin
            Y = A ^ B;
        end

        // NOT A
        3'b101: begin
            Y = ~A;
        end

        // Increment
        3'b110: begin
            Y = A + 8'b00000001;
            Carry = (A == 8'b11111111);
        end

        // Decrement
        3'b111: begin
            Y = A - 8'b00000001;
            Carry = (A == 8'b00000000);
        end

        default: begin
            Y = 8'b00000000;
            Carry = 1'b0;
        end

    endcase
end

assign Zero = (Y == 8'b00000000);

endmodule
