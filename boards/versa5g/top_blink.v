module top (
    input wire clk,
    output wire [7:0] led
);
    blink #(.W(30)) u_blink (.clk(clk), .led(led));
endmodule