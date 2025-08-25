module clock_interface (

input logic clock; // 100 MHz clock
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








endmodule