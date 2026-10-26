`default_nettype none

module sw_to_led (
    input wire [7:0] sw,
    output wire [7:0] led
);

    assign led = ~ sw;
endmodule