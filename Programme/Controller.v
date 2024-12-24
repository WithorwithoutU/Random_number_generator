module Controller (
    input wire clk,
    input wire reset,
    input wire key_count,      // Active high when KEY[2] is pressed
    output reg counting,
    output reg display_active,
    input wire [31:0] counter_value,
    output reg [6:0] count_value
);

    reg last_key_count;        // To detect edges of key_count
    reg system_active;
    reg [2:0] display_count;
    reg [91:0] generated_flags; // 92-bit flag register to track generated numbers
    reg display_active_pulse;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            system_active <= 1;
            counting <= 0;
            display_active <= 0;
            display_active_pulse <= 0;
            display_count <= 0;
            generated_flags <= 0;
            last_key_count <= 0;
            count_value <= 0;
        end else if (system_active) begin
            last_key_count <= key_count;

            // Detect rising edge of key_count to start counting
            if (key_count && !last_key_count && !counting && display_count < 7) begin
                counting <= 1;     // Start counting
            end
            // Detect falling edge of key_count to stop counting and generate number
            else if (!key_count && last_key_count && counting && display_count < 7) begin
                // Random number generation logic
                reg [6:0] new_value;
                integer attempts;
                attempts = 0;
                new_value = (counter_value % 92) + 1;

                // Ensure the number hasn't been generated before
                while (generated_flags[new_value - 1] && attempts < 92) begin
                    new_value = (new_value % 92) + 1;
                    attempts = attempts + 1;
                end

                // Update count_value and mark the number as generated
                if (attempts < 92) begin
                    count_value <= new_value;
                    generated_flags[new_value - 1] <= 1; // Mark as generated
                end

                display_count <= display_count + 1; // Increment display count
                counting <= 0;                      // Stop counting
                display_active <= 1;                // Activate display
                display_active_pulse <= 1;          // Set pulse flag
            end else begin
                // Reset display_active after one clock cycle
                if (display_active_pulse) begin
                    display_active <= 0;
                    display_active_pulse <= 0;
                end
            end
        end
    end

endmodule