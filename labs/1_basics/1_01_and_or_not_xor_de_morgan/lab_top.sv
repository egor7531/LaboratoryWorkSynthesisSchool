
`include "config.svh"

module lab_top
# (
    parameter  clk_mhz       = 50,
               w_key         = 4,
               w_sw          = 8,
               w_led         = 8,
               w_digit       = 8,
               w_gpio        = 100,

               screen_width  = 640,
               screen_height = 480,

               w_red         = 4,
               w_green       = 4,
               w_blue        = 4,

               w_x           = $clog2 ( screen_width  ),
               w_y           = $clog2 ( screen_height )
)
(
    input                        clk,
    input                        slow_clk,
    input                        rst,

    // Keys, switches, LEDs

    input        [w_key   - 1:0] key,
    input        [w_sw    - 1:0] sw,
    output logic [w_led   - 1:0] led,

    // A dynamic seven-segment display

    output logic [          7:0] abcdefgh,
    output logic [w_digit - 1:0] digit,

    // Graphics

    input        [w_x     - 1:0] x,
    input        [w_y     - 1:0] y,

    output logic [w_red   - 1:0] red,
    output logic [w_green - 1:0] green,
    output logic [w_blue  - 1:0] blue,

    // Microphone, sound output and UART

    input        [         23:0] mic,
    output       [         15:0] sound,

    input                        uart_rx,
    output                       uart_tx,

    // General-purpose Input/Output

    inout        [w_gpio  - 1:0] gpio
);

    //------------------------------------------------------------------------

    // assign led        = '0;
       assign abcdefgh   = '0;
       assign digit      = '0;
       assign red        = '0;
       assign green      = '0;
       assign blue       = '0;
       assign sound      = '0;
       assign uart_tx    = '1;

    //------------------------------------------------------------------------

    wire a = key [0];
    wire b = key [1];

    wire result = a ^ b;

    //assign led [0] = result;

<<<<<<< HEAD
    assign led [1] = key [0] ^ key [1];
    // assign led [2] = a ^ b;
=======
    //assign led [1] = key [0] ^ key [1];
    //assign led [2] = a ^ b;
>>>>>>> 13a43d2 (I did all the labs of the first two classes)

    //------------------------------------------------------------------------

    /*
    `ifndef VERILATOR

    generate
        if (w_led > 2)
        begin : unused_led
            assign led [w_led - 1:2] = '0;
        end
    endgenerate

    `endif
    */

    //------------------------------------------------------------------------

    // Exercise 1: Change the code below.
    // Assign to led [2] the result of AND operation.
    //
    // If led [2] is not available on your board,
    // comment out the code above and reuse led [0].

    assign led [2] = a & b;

    // Exercise 2: Change the code below.
    // Assign to led [3] the result of XOR operation
    // without using "^" operation.
    // Use only operations "&", "|", "~" and parenthesis, "(" and ")".

    assign led [3] = a & (~b) | ~a & b;

    // Exercise 3: Create an illustration to De Morgan's laws:
    // ~ (a & b) == ~ a | ~ b   
    // ~ (a | b) == ~ a & ~ b

    //assign led [0] = ~ (a & b);
    //assign led [1] = ~ a | ~ b;

    //assign led [0] = ~ (a | b);
    //assign led [1] = ~ a & ~ b;

endmodule
