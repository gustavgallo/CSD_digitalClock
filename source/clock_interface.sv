module clock_interface (

input logic clock; // 100 MHz clock
input logic reset; // reset 
input logic pulse_1hz; // 1 hz pulse to count the seconds of the digital clock
input logic mode_button;
input logic add_button;
input logic sub_button;

output logic[5:0] d1, d2, d3, d4, d5, d6, d7, d8 // displays
);

typedef enum logic [2:0] { // tava 1:0, coloquei 2:0 pra caber os estados

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








endmodule