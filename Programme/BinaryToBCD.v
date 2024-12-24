module BinaryToBCD (
    input wire [6:0] binary,
    output reg [3:0] tens,
    output reg [3:0] ones
);

    always @(*) begin
        tens = binary / 10;
        ones = binary % 10;
    end

endmodule