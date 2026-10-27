`default_nettype none

module top (
    input  wire         clk,
    input  wire         btn_n,
    input  wire [7:0]   sw,
    output wire [7:0]   led,
    output wire [1:0]   tp
);

    wire a;
    button_pulse u_btn (.clk(clk), .btn_n(btn_n), .pulse(a));

    wire b_s, sel_s, clr_s, busy_s;
    sync2 u_s1 (.clk(clk), .d(~sw[1]), .q(b_s));
    sync2 u_s2 (.clk(clk), .d(~sw[2]), .q(sel_s));
    sync2 u_s3 (.clk(clk), .d(~sw[3]), .q(clr_s));
    sync2 u_s7 (.clk(clk), .d(~sw[7]), .q(busy_s));

    wire trig, vetoed, busy;
    trigger_logic #(.GATE(4), .DEAD(50_000_000)) u_rig(
        .clk(clk),
        .a(a),
        .b(b_s),
        .busy_in(busy_s),
        .trig(trig),
        .vetoed(vetoed),
        .busy(busy)        
    );

    wire [15:0] n_trig, n_veto;
    trig_counter u_cnt (
        .clk(clk),
        .clr(clr_s),
        .trig(trig),
        .vetoed(vetoed),
        .n_trig(n_trig),
        .n_veto(n_veto)
    );

    assign led = ~(sel_s ? n_veto[7:0] : n_trig[7:0]);
    assign tp[0] = trig;
    assign tp[1] = busy;
endmodule