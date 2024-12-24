module Assignment1 (
    input wire CLOCK_50,     // 50MHz clock
    input wire KEY_reset,    // Reset key input (was KEY[3])
    input wire KEY_count,    // Counting control key input (was KEY[2])
    output wire [6:0] HEX2,  // HEX2 output for tens digit display
    output wire [6:0] HEX1   // HEX1 output for ones digit display
);

    wire counting;
    wire display_active;
    wire [31:0] counter_value;
    wire [6:0] count_value;
    wire [3:0] tens_digit;
    wire [3:0] ones_digit;
    wire display_enable;
    wire reset_pulse;

    // Instantiate ResetPulseGenerator module
    ResetPulseGenerator reset_gen (
        .clk(CLOCK_50),
        .key_reset(KEY_reset),    // Active high trigger
        .reset_pulse(reset_pulse)
    );

    // Instantiate Controller module with reset_pulse as reset signal
    Controller ctrl (
        .clk(CLOCK_50),
        .reset(reset_pulse),      // Single pulse reset signal
        .key_count(KEY_count),    // Active high trigger
        .counting(counting),
        .display_active(display_active),
        .counter_value(counter_value),
        .count_value(count_value)
    );

    // Instantiate Counter module
    Counter cnt (
        .clk(CLOCK_50),
        .reset(reset_pulse),
        .enable(counting),
        .counter_value(counter_value)
    );

    // Instantiate DisplayTimer module
    DisplayTimer disp (
        .clk(CLOCK_50),
        .reset(reset_pulse),
        .display_active(display_active),
        .display_enable(display_enable)
    );

    // Instantiate BinaryToBCD module
    BinaryToBCD bcd (
        .binary(count_value),
        .tens(tens_digit),
        .ones(ones_digit)
    );

    // Instantiate seven-segment decoder for tens digit
    SevenSegmentDecoder sseg_tens (
        .digit(tens_digit),
        .enable(display_enable),
        .seg_out(HEX2)
    );

    // Instantiate seven-segment decoder for ones digit
    SevenSegmentDecoder sseg_ones (
        .digit(ones_digit),
        .enable(display_enable),
        .seg_out(HEX1)
    );

endmodule

