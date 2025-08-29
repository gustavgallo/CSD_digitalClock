`timescale 1ns/1ps

module top_tb;

    // Inputs
    logic clock;
    logic reset;
    logic mode_buttonBTNC;
    logic add_buttonBTNR;
    logic sub_buttonBTNL;

    // Outputs
    logic [7:0] AN;
    logic [7:0] DIGIT;

    // Instancia o módulo top
    top uut (
        .clock(clock),
        .reset(reset),
        .mode_buttonBTNC(mode_buttonBTNC),
        .add_buttonBTNR(add_buttonBTNR),
        .sub_buttonBTNL(sub_buttonBTNL),
        .AN(AN),
        .DIGIT(DIGIT)
    );

    // Clock generator (100 MHz)
    initial clock = 0;
    always #5 clock = ~clock; // 100 MHz -> período de 10 ns

    // Stimulus inicial
    initial begin
        // Inicialização
        reset = 0;
        mode_buttonBTNC = 0;
        add_buttonBTNR = 0;
        sub_buttonBTNL = 0;

        // Solta o reset após 100 ns
        #1000;
        reset = 1;

        #1000;
        reset = 0;

        
        
    end

    // Monitorar alguns sinais
    initial begin
        $display("Tempo\tReset\tMode\tAdd\tSub\tAN\tDIGIT");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%h\t%h",
                 $time, reset, mode_buttonBTNC, add_buttonBTNR, sub_buttonBTNL, AN, DIGIT);
    end

endmodule
