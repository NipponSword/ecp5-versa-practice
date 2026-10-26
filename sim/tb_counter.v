`timescale 1ns/1ps
`default_nettype none

module tb_counter;
    reg clk = 0;
    reg a = 0, b = 0, busy_in = 0, clr = 0;
    wire trig, vetoed, busy;
    wire [15:0] n_trig, n_veto;

    always #5 clk = ~clk;

    trigger_logic #(.GATE(4), .DEAD(20)) u_trig (
        .clk(clk),
        .a(a),
        .b(b),
        .busy_in(busy_in),
        .trig(trig),
        .vetoed(vetoed),
        .busy(busy)
    );

    trig_counter u_cnt (
        .clk(clk),
        .clr(clr),
        .trig(trig),
        .vetoed(vetoed),
        .n_trig(n_trig),
        .n_veto(n_veto)
    );

    task wait_clk(input integer n); 
        begin 
            repeat (n) @(posedge clk); #1; 
        end 
    endtask
    
    task coin; 
        begin 
            a = 1; b =1; @(posedge clk); 
            #1 
            a = 0; b = 0; 
        end 
        endtask

    integer errors = 0;
    task check(input [8*24-1:0] name, input integer got, input integer exp);
        begin
            if (got !== exp) begin
                $display("FAIL: %0s = %0d (expected %0d)", name, got, exp);
                errors = errors + 1;
            end else
                $display("ok : %0s = %0d", name, got);
        end
    endtask

    integer i;
    initial begin
        wait_clk(3);

        for (i = 0; i < 100; i = i + 1) begin
            coin;
            wait_clk(6);
        end

        // test 1 : 100 coinc every 7 clks
        wait_clk(30);
        check("n_trig",          n_trig,          34);
        check("n_veto",          n_veto,          66);
        check("n_trig + n_veto", n_trig + n_veto, 100);

        // test 2 : return to 0 by clr
        clr = 1; 
        wait_clk(1);
        clr = 0;
        check("n_trig after clr",  n_trig, 0);

        // test 3 : vetoed by external busy
        busy_in = 1;
        for (i = 0; i < 10; i = i + 1) begin coin; wait_clk(30); end
        busy_in = 0;
        wait_clk(30);
        check("n_trig while busy", n_trig, 0);
        check("n_veto while busy", n_veto, 10);

        if (errors == 0) $display("===== PASS =====");
        else             $display("===== FAIL: %0d 件 =====", errors);
        $finish;
    end
endmodule