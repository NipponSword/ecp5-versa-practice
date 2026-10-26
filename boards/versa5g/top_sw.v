`default_nettype none

module top (
    input wire [7:0] sw,
    output wire [7:0] led
);
    wire both_on = ~sw[0] & ~sw[4];
    assign led[0] = ~both_on;
    assign led[7:1] = 7'b111_1111;

endmodule