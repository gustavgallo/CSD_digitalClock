module top (

input logic clock, // clock input da nexys
input logic reset, // reset da nexys
input logic mode_buttonBTNC, // vem da placa
input logic add_buttonBTNR, // vem da placa
input logic sub_buttonBTNL, // vem da placa

output logic [7:0] AN,
output logic [7:0] DIGIT

);
parameter [31:0] DEB_DELAY = 1000000;
parameter [31:0] HALF_MS_COUNT=50000;

logic[5:0] d1, d2, d3, d4, d5, d6, d7, d8; // displays
logic pulse_1hz; // 1 hz pulse to count the seconds of the digital clock
logic pulse_500ms; // 500 ms pulse to blink the colon of the digital clock
// debounced buttons
logic mode_buttonDEBOUNCED;
logic add_buttonDEBOUNCED;
logic sub_buttonDEBOUNCED;


debounce #(
    .DELAY(DEB_DELAY)
    ) 
mode(
    .clk_i(clock),
    .rst_i(reset),
    .key_i(mode_buttonBTNC),
    .debkey_o(mode_buttonDEBOUNCED)

);

debounce #(
    .DELAY(DEB_DELAY)
    ) 
add(
    .clk_i(clock),
    .rst_i(reset),
    .key_i(add_buttonBTNR),
    .debkey_o(add_buttonDEBOUNCED)

);

debounce #(
    .DELAY(DEB_DELAY)
    ) 
sub(
    .clk_i(clock),
    .rst_i(reset),
    .key_i(sub_buttonBTNL),
    .debkey_o(sub_buttonDEBOUNCED)

);

dspl_drv_8dig 
	display(
		.clock(clock),
		.reset(reset),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.d4(d4),
		.d5(d5),
		.d6(d6),
		.d7(d7),
		.d8(d8),
		.an(AN),
		.dec_ddp(DIGIT)
	);

clock_divisor   divisor(
    .clk(clock),        // 100 MHz clock input
    .rst_i(reset),      // Active-low synchronous reset
    .pulse_1hz(pulse_1hz),  // 1 Hz pulse output
    .pulse_500ms(pulse_500ms) // 500 ms pulse output
);

clock_interface     main( 
.clock(clock), // 100 MHz clock
.reset(reset), // reset 
.pulse_1hz(pulse_1hz), // 1 hz pulse to count the seconds of the digital clock
.pulse_500ms(pulse_500ms), // 500 ms pulse to blink the colon of the digital clock
.mode_button(mode_buttonDEBOUNCED),
.add_button(add_buttonDEBOUNCED),
.sub_button(sub_buttonDEBOUNCED),
.d1(d1),
.d2(d2),
.d3(d3),
.d4(d4),
.d5(d5),
.d6(d6),
.d7(d7),
.d8(d8)

);








endmodule