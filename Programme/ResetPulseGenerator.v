module ResetPulseGenerator(
    input wire clk,
    input wire key_reset,
    output reg reset_pulse
);
    reg key_reset_d1, key_reset_d2;

    always @(posedge clk) begin
        key_reset_d1 <= key_reset;
        key_reset_d2 <= key_reset_d1;

        // Detect rising edge of key_reset, generate single clock cycle pulse
        if (key_reset_d1 && !key_reset_d2)
            reset_pulse <= 1;
        else
            reset_pulse <= 0;
    end
endmodule