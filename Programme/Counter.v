module Counter (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [31:0] counter_value
);

    reg last_enable;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_value <= 0;
            last_enable <= 0;
        end else begin
            if (enable && !last_enable) begin
                counter_value <= 1;  // Start counting from 1 on rising edge of enable
            end else if (enable) begin
                counter_value <= counter_value + 1;
            end
            last_enable <= enable;
        end
    end

endmodule