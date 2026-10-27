`default_nettype none

module top (
    input  wire         clk,
    output wire [7:0]   led,
    output wire [1:0]   tp,
);
    // 100 MHz -> PLL -> 50MHz
    wire clk40, locked;
    pll40 u_pll (.clkin(clk), .clkout0(clk40), .locked(locked));

    // Bling LEDs with 40MHz clk
    wire [7:0] led_blink;
    blink #(.W(30)) u_blink (.clk(clk40), .led(led_blink));

    assign led      = {led_blink[7:1], ~locked};
    assign tp[0]    = clk40;
    assign tp[1]    = locked;
endmodule