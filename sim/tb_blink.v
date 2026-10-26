`timescale 1ns/1ps
`default_nettype none

module tb_blink;

    reg clk = 0;
    wire [7:0] led;

    always #5 clk = ~clk;

    blink #(
        .W(10)
    ) dut (
        .clk(clk),
        .led(led)
    );

    initial begin
        $dumpfile("sim/output/blink.vcd");
        $dumpvars(0, tb_blink);
        #20000;
        $finish;
    end

    always @(led) $display("t=%0d ns led=%b", $time, ~led);
endmodule   