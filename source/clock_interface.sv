module clock_interface ( //talvez seja melhor mudar o nome para watch, para não confundir com clock

input logic clock, // 100 MHz clock
input logic reset, // reset 
input logic pulse_1hz, // 1 hz pulse to count the seconds of the digital clock
input logic pulse_500ms, // 500 ms pulse to blink the colon of the digital clock
input logic mode_button,
input logic add_button,
input logic sub_button,

output logic[5:0] d1, d2, d3, d4, d5, d6, d7, d8 // displays
);

typedef enum logic [2:0] { // FSM pra definir se é o estado de rodar normalmente o relógio, ou pra modificar as hrs/min/seg

    RUN,

    SET_HOURS,

    SET_MINUTES,

    SET_SECONDS

} state_t;

state_t EA;
logic [5:0] seconds;
logic [5:0] minutes;
logic [4:0] hours;


// Always da FSM
always_ff @(posedge clock or posedge reset)begin

    if(reset)begin
        EA <= RUN;
    end else begin

        case(EA)

            RUN:begin
                if(mode_button) begin   EA <= SET_HOURS;        
                end else EA <= RUN;
            end

            SET_HOURS:begin
                if(mode_button) begin   EA <= SET_MINUTES;        
                end else EA <= SET_HOURS;
            end

            SET_MINUTES:begin
                if(mode_button) begin   EA <= SET_SECONDS;        
                end else EA <= SET_MINUTES;
            end

            SET_SECONDS:begin
                if(mode_button) begin   EA <= RUN;        
                end else EA <= SET_SECONDS;
            end

        endcase
    end
end



// Always: set_time_logic
always_ff @(posedge clock) begin // lógica para setar valores de hora, minuto, segundo
        case (EA)
            RUN: begin
                if (seconds < 59) begin
                    seconds <= seconds + 1;
                end else begin
                    seconds <= 0;
                    // Incrementa minutos
                    if (minutes < 59) begin
                        minutes <= minutes + 1;
                    end else begin
                        minutes <= 0;
                        // Incrementa horas
                        if (hours < 23) begin
                            hours <= hours + 1;
                        end else begin
                            hours <= 0;
                        end
                    end
                end
            end

            SET_HOURS: begin
                if (add_button) begin
                    if (hours < 23)
                        hours <= hours + 1;
                    else
                        hours <= 0;
                end else if (sub_button) begin
                    if (hours > 0)
                        hours <= hours - 1;
                    else
                        hours <= 23;
                end
            end

            SET_MINUTES: begin
                if (add_button) begin
                    if (minutes < 59)
                        minutes <= minutes + 1;
                    else
                        minutes <= 0;
                end else if (sub_button) begin
                    if (minutes > 0)
                        minutes <= minutes - 1;
                    else
                        minutes <= 59;
                end
            end

            SET_SECONDS: begin
                if (add_button) begin
                    if (seconds < 59)
                        seconds <= seconds + 1;
                    else
                        seconds <= 0;
                end else if (sub_button) begin
                    if (seconds > 0)
                        seconds <= seconds - 1;
                    else
                        seconds <= 59;
                end
            end

            default: ; // RUN or undefined state: do nothing
        endcase
end

// Always: display_logic, não fiz ainda ele piscando os números que estão sendo ajustados
always_ff @(posedge clock)begin 
    case(EA)
        RUN: begin
            // Nos estados de RUN, todos(pq essa palavra ta vermeia?) os dígitos são exibidos normalmente
            d8 <= {1'b1, hours / 10, 1'b1};        // Dezena das horas
            d7 <= {1'b1, hours % 10, 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, minutes / 10, 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, minutes % 10, 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, seconds / 10, 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, seconds % 10, 1'b1};      // Unidade dos segundos
        end
        SET_HOURS: begin
            d8 <= {pulse_500ms, hours / 10, 1'b1};        // Dezena das horas
            d7 <= {pulse_500ms, hours % 10, 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, minutes / 10, 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, minutes % 10, 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, seconds / 10, 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, seconds % 10, 1'b1};      // Unidade dos segundos
        end
        SET_MINUTES: begin
            d8 <= {1'b1, hours / 10, 1'b1};        // Dezena das horas
            d7 <= {1'b1, hours % 10, 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {pulse_500ms, minutes / 10, 1'b1};      // Dezena dos minutos
            d4 <= {pulse_500ms, minutes % 10, 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, seconds / 10, 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, seconds % 10, 1'b1};      // Unidade dos segundos
        end
        SET_SECONDS: begin
            d8 <= {1'b1, hours / 10, 1'b1};        // Dezena das horas
            d7 <= {1'b1, hours % 10, 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, minutes / 10, 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, minutes % 10, 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {pulse_500ms, seconds / 10, 1'b1};      // Dezena dos segundos
            d1 <= {pulse_500ms, seconds % 10, 1'b1};      // Unidade dos segundos
        end
    endcase
end


endmodule