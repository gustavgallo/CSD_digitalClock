module clock_interface (

input logic clock; // 100 MHz clock
input logic reset; // reset 
input logic pulse_1hz; // 1 hz pulse to count the seconds of the digital clock
input logic mode_button;
input logic add_button;
input logic sub_button;

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
always_ff @(posedge clock or negedge reset)begin

    if(!reset)begin
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

// Always: seconds_counter
always_ff @(posedge pulse_1hz or negedge reset) begin
    if (!reset) begin
        seconds <= 0;
        minutes <= 0;
        hours   <= 0;
    end else if (EA == RUN) begin
        // Incrementa segundos
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
end

always_ff @(posedge clock or negedge reset) begin // logica para settar os valores de hora, minuto, segundo.
    if (EA == SET_HOURS) begin                    // fiz em outro always pq o gallo disse q ficava mais organizado
        if(add_button) begin
            if(hours < 23) begin
                hours <= hours + 1;
            end
             else begin
                hours <= 0;
            end
        end
        else if(sub_button) begin
            hours <= hours - 1;
        end
    end
    else if(EA == SET_MINUTES) begin
         if(add_button) begin
            if(minutes < 59) begin
                minutes <= minutes + 1;
            end
             else begin
                minutes <= 0;
            end
        end
        else if(sub_button) begin
            minutes <= minutes - 1;
        end 
    end
    else if(EA == SET_SECONDS) begin
     if(add_button) begin
            if(seconds < 59) begin
                seconds <= seconds + 1;
            end
             else begin
                seconds <= 0;
            end
        end
        else if(sub_button) begin
            seconds <= seconds - 1;
        end
    end
end



endmodule