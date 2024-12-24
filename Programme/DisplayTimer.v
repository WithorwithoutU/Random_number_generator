module DisplayTimer (
    input wire clk,
    input wire reset,
    input wire display_active,
    output reg display_enable
);

    reg [28:0] display_timer;  // Display timer to control the duration of display
    reg display_on;
    reg display_active_d;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            display_timer <= 0;
            display_on <= 0;
            display_enable <= 0;
            display_active_d <= 0;
        end else begin
            display_active_d <= display_active;
            if (display_active && !display_active_d) begin
                // Detect rising edge of display_active
                display_on <= 1;
                display_timer <= 0;
            end else if (display_on) begin
				if (display_timer < 350_000_000) begin // Display duration is 7 seconds (350,000,000 clock cycles)

                    display_timer <= display_timer + 1;
                end else begin
                    display_on <= 0;          // End timing, turn off display
                end
            end

            display_enable <= display_on;
        end
    end

endmodule