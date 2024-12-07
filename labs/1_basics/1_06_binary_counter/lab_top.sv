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

    // Exercise 1: Free running counter.
    // How do you change the speed of LED blinking?
    // Try different bit slices to display.

    /*    
    localparam w_cnt = $clog2 (clk_mhz * 1000 * 1000);

    logic [w_cnt - 1:0] cnt;        // [25:0] cnt

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt <= '0;
        else
            cnt <= cnt + 2'd2;

    assign led = cnt [$left(cnt) -: w_led]; // cnt [$left (cnt) : $left (cnt) - w_led + 1] - cnt [25:22]
    */

    // Exercise 2: Key-controlled counter.
    // Comment out the code above.
    // Uncomment and synthesize the code below.
    // Press the key to see the counter incrementing.
    
    /*
    wire any_key = | key;

    logic any_key_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            any_key_r <= '0;
        else
            any_key_r <= any_key;

    wire any_key_pressed = ~ any_key & any_key_r;

    logic [w_led - 1:0] cnt;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt <= '0;
        else if (any_key_pressed)
            cnt <= cnt + 1'd1;

    assign led = w_led' (cnt);
    */

    // Change the design, for example:
    //
    // 1. One key is used to increment, another to decrement.
    
    /*
    wire inc_key = key[0];
    wire dec_key = key[1];

    logic inc_key_r;
    logic dec_key_r;

    logic [w_led - 1:0] cnt;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            inc_key_r <= '0;
        else
            inc_key_r <= inc_key;

    wire inc_key_pressed = ~ inc_key & inc_key_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            dec_key_r <= '0;
        else
            dec_key_r <= dec_key;

    wire dec_key_pressed = ~ dec_key & dec_key_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt <= '0;
        else begin
            if (dec_key_pressed)
                cnt <= cnt - 1'd1;
            if (inc_key_pressed)
                cnt <= cnt + 1'd1;
        end

    assign led = w_led' (cnt);
    */

    // 2. Two counters controlled by different keys
    // displayed in different groups of LEDs.

    wire key1 = key[0];
    wire key2 = key[1];
    
    logic key1_r;
    logic key2_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            key1_r <= '0;
        else
            key1_r <= key1;

    wire key1_pressed = ~ key1 & key1_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            key2_r <= '0;
        else
            key2_r <= key2;

    wire key2_pressed = ~ key2 & key2_r;

    logic [w_led/2 - 1:0] cnt1;
    logic [w_led - 1: w_led/2] cnt2;

    always_ff @ (posedge clk or posedge rst)
        if (rst) begin
            cnt1 <= '0;
            cnt2 <= '0;
        end
        
        else begin
            if (key1_pressed)
                cnt1 <= cnt1 + 1'd1;
            if (key2_pressed)
                cnt2 <= cnt2 + 1'd1;
        end

    assign led = w_led' ({cnt2, cnt1});

endmodule
