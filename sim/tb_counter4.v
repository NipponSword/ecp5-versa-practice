`timescale 1ns/1ps
`default_nettype none

module tb_counter4;
    reg clk = 0;
    reg en = 0;
    wire [3:0] q;

    always #5 clk = ~clk;

    counter4 dut (.clk(clk), .en(en), .q(q));

    initial begin
        $dumpfile("sim/output/counter4.vcd");
        $dumpvars(0, tb_counter4);
        
        #20;
        en = 1;
        #100;
        en = 0;
        #100;

        $finish;
    end

    always @(posedge clk) $display("t=%0d ns en=%b q=%d", $time, en, q);
endmodule