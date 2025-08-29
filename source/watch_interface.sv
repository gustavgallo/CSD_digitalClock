module watch_interface ( //talvez seja melhor mudar o nome para watch, para não confundir com clock

input logic clock, // 100 MHz clock
input logic reset, // reset 
input logic pulse_1hz, // 1 hz pulse to count the seconds of the digital clock
input logic pulse_500ms, // 500 ms pulse to blink the colon of the digital clock
input logic mode_button,
input logic add_button,
input logic sub_button,
input logic[15:0] sw,

output logic[5:0] d1, d2, d3, d4, d5, d6, d7, d8 // displays
);

assign secret_code = (sw[15:0] == 16'b1010101010101010)? 1:0;
logic start = 0;

typedef enum logic [2:0] { // FSM pra definir se é o estado de rodar normalmente o relógio, ou pra modificar as hrs/min/seg

    RUN,

    SET_HOURS,

    SET_MINUTES,

    SET_SECONDS,

    UNLOCKED

} state_t;

state_t EA;
logic [3:0] U_seconds, D_seconds;
logic [3:0] U_minutes, D_minutes;
logic [3:0] U_hours, D_hours;


// Always da FSM
always_ff @(posedge clock, posedge reset)begin

    if(reset)begin
        EA <= RUN;
    end else begin

        case(EA)

            RUN:begin
                if(mode_button) begin   EA <= SET_HOURS;        
                end else if(secret_code) EA <= UNLOCKED;
                else EA <= RUN;
            end

            SET_HOURS:begin
                if(mode_button) begin   EA <= SET_MINUTES;
                end else if(secret_code) EA <= UNLOCKED;
                else EA <= SET_HOURS;
            end

            SET_MINUTES:begin
                if(mode_button) begin   EA <= SET_SECONDS;        
                end else if(secret_code) EA <= UNLOCKED;
                else EA <= SET_MINUTES;
            end

            SET_SECONDS:begin
                if(mode_button) begin   EA <= RUN;
                end else if(secret_code) EA <= UNLOCKED;
                else EA <= SET_SECONDS;
            end

            UNLOCKED: begin
                if(secret_code) begin
                    EA <= UNLOCKED;
                end
                else EA <= RUN;
            end

        endcase
    end
end



// Always: set_time_logic
always_ff @(posedge clock, posedge reset) begin // lógica para setar valores de hora, minuto, segundo
    if(reset) begin
        U_hours <=0;
        U_minutes <=0;
        U_seconds <=0;
        D_hours <=0;
        D_minutes <=0;
        D_seconds <=0;
    end else begin
        case (EA)
            RUN: begin
                if(pulse_1hz) begin
                if (U_seconds < 9) begin
                    U_seconds <= U_seconds + 1;
                end else begin
                    U_seconds <= 0;
                    if (D_seconds < 5) begin
                        D_seconds <= D_seconds + 1;
                    end else begin
                        D_seconds <= 0;
                        if (U_minutes < 9) begin
                            U_minutes <= U_minutes + 1;
                        end else begin
                            U_minutes <= 0;
                            if (D_minutes < 5) begin
                                D_minutes <= D_minutes + 1;
                            end else begin
                                D_minutes <= 0;
                                if (D_hours < 2 || (D_hours == 2 && U_hours < 3)) begin
                                    if (U_hours < 9) begin
                                        U_hours <= U_hours + 1;
                                    end else begin
                                        U_hours <= 0;
                                        D_hours <= D_hours + 1;
                                    end
                                end else begin
                                    U_hours <= 0;
                                    D_hours <= 0;
                                end
                            end
                        end
                    end
                end
            end
            end
       // Ajuste das HORAS (0–23)
SET_HOURS: begin
    if (add_button) begin
        if (D_hours < 2 || (D_hours == 2 && U_hours < 3)) begin
            if (U_hours < 9)
                U_hours <= U_hours + 1;
            else begin
                U_hours <= 0;
                D_hours <= D_hours + 1;
            end
        end else begin
            // Volta para 00
            U_hours <= 0;
            D_hours <= 0;
        end
    end else if (sub_button) begin
        if (D_hours > 0 || (D_hours == 0 && U_hours > 0)) begin
            if (U_hours > 0)
                U_hours <= U_hours - 1;
            else begin
                U_hours <= 9;
                D_hours <= D_hours - 1;
            end
        end else begin
            // Volta para 23
            U_hours <= 3;
            D_hours <= 2;
        end
    end
end

// Ajuste dos MINUTOS (0–59)
SET_MINUTES: begin
    if (add_button) begin
        if (D_minutes < 5) begin
            if (U_minutes < 9)
                U_minutes <= U_minutes + 1;
            else begin
                U_minutes <= 0;
                D_minutes <= D_minutes + 1;
            end
        end else begin
            // Volta para 00
            U_minutes <= 0;
            D_minutes <= 0;
        end
    end else if (sub_button) begin
        if (D_minutes > 0 || (D_minutes == 0 && U_minutes > 0)) begin
            if (U_minutes > 0)
                U_minutes <= U_minutes - 1;
            else begin
                U_minutes <= 9;
                D_minutes <= D_minutes - 1;
            end
        end else begin
            // Volta para 59
            U_minutes <= 9;
            D_minutes <= 5;
        end
    end
end

// Ajuste dos SEGUNDOS (0–59)
SET_SECONDS: begin
    if (add_button) begin
        if (D_seconds < 5) begin
            if (U_seconds < 9)
                U_seconds <= U_seconds + 1;
            else begin
                U_seconds <= 0;
                D_seconds <= D_seconds + 1;
            end
        end else begin
            // Volta para 00
            U_seconds <= 0;
            D_seconds <= 0;
        end
    end else if (sub_button) begin
        if (D_seconds > 0 || (D_seconds == 0 && U_seconds > 0)) begin
            if (U_seconds > 0)
                U_seconds <= U_seconds - 1;
            else begin
                U_seconds <= 9;
                D_seconds <= D_seconds - 1;
            end
        end else begin
            // Volta para 59
            U_seconds <= 9;
            D_seconds <= 5;
        end
    end
end
UNLOCKED: begin
    if(pulse_1hz) begin
        if(!start) begin
            start <= 1;
            U_hours <=9;
            U_minutes <=9;
            U_seconds <=9;
            D_hours <=9;
            D_minutes <=9;
            D_seconds <=9;
        end
                if (U_seconds > 0) begin
                    U_seconds <= U_seconds - 1;
                end else begin
                    U_seconds <= 0;
                    if (D_seconds > 0) begin
                        D_seconds <= D_seconds - 1;
                    end else begin
                        D_seconds <= 0;
                        if (U_minutes > 0) begin
                            U_minutes <= U_minutes - 1;
                        end else begin
                            U_minutes <= 9;
                            if (D_minutes > 0) begin
                                D_minutes <= D_minutes - 1;
                            end else begin
                                D_minutes <= 0;
                                    if (U_hours > 0) begin
                                        U_hours <= U_hours - 1;
                                    end else begin
                                        U_hours <= 0;
                                        D_hours <= D_hours - 1;
                                    end
                                end else begin
                                    U_hours <= 0;
                                    D_hours <= 0;
                                end
                            end
                        end
                    end
                end
            end
            default: begin
                // estado de segurança
                U_hours   <= 0;
                U_minutes <= 0;
                U_seconds <= 0;
                D_hours   <= 0;
                D_minutes <= 0;
                D_seconds <= 0;
                start     <= 0;
            end

        endcase
    end
end

// Always: display_logic, não fiz ainda ele piscando os números que estão sendo ajustados
always_ff @(posedge clock)begin 
    case(EA)
        RUN: begin
            // Nos estados de RUN, todos(pq essa palavra ta vermeia?) os dígitos são exibidos normalmente
            d8 <= {1'b1, D_hours, 1'b1};        // Dezena das horas
            d7 <= {1'b1, U_hours, 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, D_minutes , 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, U_minutes , 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, D_seconds , 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, U_seconds , 1'b1};      // Unidade dos segundos
        end
        SET_HOURS: begin
            d8 <= {pulse_500ms, D_hours , 1'b1};        // Dezena das horas
            d7 <= {pulse_500ms, U_hours , 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, D_minutes , 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, U_minutes , 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, D_seconds , 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, U_seconds , 1'b1};      // Unidade dos segundos
        end
        SET_MINUTES: begin
            d8 <= {1'b1, D_hours , 1'b1};        // Dezena das horas
            d7 <= {1'b1, U_hours , 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {pulse_500ms, D_minutes , 1'b1};      // Dezena dos minutos
            d4 <= {pulse_500ms, U_minutes , 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, D_seconds , 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, U_seconds , 1'b1};      // Unidade dos segundos
        end
        SET_SECONDS: begin
            d8 <= {1'b1, D_hours , 1'b1};        // Dezena das horas
            d7 <= {1'b1, U_hours , 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, D_minutes , 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, U_minutes , 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {pulse_500ms, D_seconds , 1'b1};      // Dezena dos segundos
            d1 <= {pulse_500ms, U_seconds , 1'b1};      // Unidade dos segundos
        end
        UNLOCKED: begin
            d8 <= {1'b1, D_hours, 1'b1};        // Dezena das horas
            d7 <= {1'b1, U_hours, 1'b1};        // Unidade das horas
            d6 <= {1'b0, 4'b0000, 1'b1};              // Display morto 
            d5 <= {1'b1, D_minutes , 1'b1};      // Dezena dos minutos
            d4 <= {1'b1, U_minutes , 1'b1};      // Unidade dos minutos
            d3 <= {1'b0, 4'b0000, 1'b1};              // Display morto denovo ( talvez a gente poderia colocar ele com umas barras acesas sla)
            d2 <= {1'b1, D_seconds , 1'b1};      // Dezena dos segundos
            d1 <= {1'b1, U_seconds , 1'b1};      // Unidade dos segundos
        end
    endcase
end


endmodule