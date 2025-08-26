module clock_divisor (
    input  logic clk,        // 100 MHz clock input
    input  logic rst_n,      // Active-low synchronous reset
    output logic pulse_1hz,  // 1 Hz pulse output
    output logic pulse_500ms // 500 ms pulse output
);

    // 100 MHz = 100,000,000 cycles per second
    localparam int COUNT_MAX    = 100000000 - 1;
    localparam int COUNT_500MS  = 50000000  - 1;

    logic [26:0] counter;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter      <= 0;
            pulse_1hz    <= 0;
            pulse_500ms  <= 0;
        end else begin
            counter <= counter + 1;
            
            if (counter == COUNT_MAX) begin
                counter <= 0;
                pulse_1hz <= 1;
            end else begin
                pulse_1hz <= 0;
            end
            
            // Corrigir para alternar a cada 500ms
            if (counter == COUNT_500MS || counter == 0) begin
                pulse_500ms <= ~pulse_500ms;
            end
        end
    end

endmodule