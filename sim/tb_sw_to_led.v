`timescale 1ns/1ps
`default_nettype none

module tb_sw_to_led;
    reg [7:0] sw;
    wire [7:0] led;

    sw_to_led dut (.sw(sw), .led(led));

    initial begin
        $dumpfile("sim/output/sw_to_led.vcd");
        $dumpvars(0, tb_sw_to_led);

        sw = 8'b0000_1111;
        #10;
        $display("sw=%b -> led=%b" , sw, led);
        $finish;
    end

endmodule