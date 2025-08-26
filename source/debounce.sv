module debounce #(
    parameter [31:0] DELAY = 500000
) (
    input wire clk_i,
    input wire rst_i,        // Reset ativo alto
    input wire key_i,
    output wire debkey_o
);

    typedef enum logic [2:0] {
        IDLE = 0,
        PRESS_WAIT = 1, 
        PRESSED = 2,
        RELEASE_WAIT = 3,
        PULSE = 4
    } state_t;

    state_t state;
    logic intclock;
    logic [31:0] clockdiv;  // Aumentado para 32 bits para suportar DELAY maior

    // FSM para debounce
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin  // Reset assíncrono ativo alto
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    if (intclock && key_i) begin
                        state <= PRESS_WAIT;
                    end
                end
                
                PRESS_WAIT: begin
                    if (intclock) begin
                        if (key_i) begin
                            state <= PRESSED;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end
                
                PRESSED: begin
                    if (intclock && !key_i) begin
                        state <= RELEASE_WAIT;
                    end
                end
                
                RELEASE_WAIT: begin
                    if (intclock) begin
                        if (!key_i) begin
                            state <= PULSE;
                        end else begin
                            state <= PRESSED;
                        end
                    end
                end
                
                PULSE: begin
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Gerador de clock interno
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin  // Reset assíncrono ativo alto
            clockdiv <= 0;
            intclock <= 1'b0;
        end else begin
            if (clockdiv < DELAY) begin  // Corrigido: < ao invés de <=
                clockdiv <= clockdiv + 1;
                intclock <= 1'b0;
            end else begin
                clockdiv <= 0;
                intclock <= 1'b1;  // Pulse por apenas 1 ciclo
            end
        end
    end

    // Saída - pulso única na detecção de borda
    assign debkey_o = (state == PULSE);

endmodule
