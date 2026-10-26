`timescale 1ns/1ps
`default_nettype none

module tb_button;
    reg clk = 0;
    reg btn = 0;
    wire btn_s, btn_db, p_raw, p_db;

    always #5 clk = ~clk;

    sync2               u_sync  (.clk(clk), .d(btn), .q(btn_s));
    debounce #(.N(4))   u_db    (.clk(clk), .d(btn_s), .q(btn_db));
    rise_detect         u_r1    (.clk(clk), .d(btn_s), .pulse(p_raw));
    rise_detect         u_r2    (.clk(clk), .d(btn_db), .pulse(p_db));

    integer n_raw = 0, n_db = 0;
    always @(posedge clk) begin
        if (p_raw) n_raw = n_raw + 1;
        if (p_db)  n_db  = n_db  + 1;
    end

    initial begin
        $dumpfile("sim/output/button.vcd");
        $dumpvars(0, tb_button);
        #103;

        btn = 1; #30;
        btn = 0; #20;
        btn = 1; #40;
        btn = 0; #15;
        btn = 1; #500;

        btn = 0; #25;
        btn = 1; #30;
        btn = 0; #500;

        $display("The number of pulses = %0d, After debounce = %0d", n_raw, n_db);
        $finish;
    end
endmodule