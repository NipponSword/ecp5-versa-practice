`default_nettype none
`timescale 1ns/1ps

module tb_trigger;
    reg clk = 0;
    reg a = 0, b = 0, busy_in = 0;
    wire trig, vetoed, busy;

    always #5 clk = ~clk;

    trigger_logic #(.GATE(4), .DEAD(20)) dut (
        .clk(clk), .a(a), .b(b), .busy_in(busy_in),
        .trig(trig), .vetoed(vetoed), .busy(busy)
    );

    task pulse_a; begin a = 1; @(posedge clk); #1 a = 0; end endtask
    task pulse_b; begin b = 1; @(posedge clk); #1 b = 0; end endtask
    task wait_clk(input integer n); begin repeat (n) @(posedge clk); #1; end endtask

    always @(posedge clk) begin
        if (trig)   $display("t=%d ns TRIG",    $time);
        if (vetoed) $display("t=%d ns VETOED",  $time);
    end

    initial begin
         $dumpfile("sim/output/trigger.vcd");
         $dumpvars(0, tb_trigger);
         wait_clk(3);

         $display(" A and B --> trigger");
         fork pulse_a; pulse_b; join
         wait_clk(30);

         $display(" A and B (after 2clk) --> trigger");
         pulse_a; wait_clk(1); pulse_b;
         wait_clk(30);

         $display(" trigger and trriger --> veto by self-busy");
         fork pulse_a; pulse_b; join
         wait_clk(8);
         fork pulse_a; pulse_b; join
         wait_clk(30);

         $display(" Busy from outside");
         busy_in = 1;
         fork pulse_a; pulse_b; join
         wait_clk(10);
         busy_in = 0;
         wait_clk(10);
         $finish;
    end
endmodule