`default_nettype none

module top(
    input  wire       clk,
    input  wire       btn_n,
    input  wire [7:0] sw,
    output wire [7:0] led,
    output wire [1:0] tp
);
    wire a;
    button_pulse u_btn (.clk, .btn_n(btn_n), .pulse(a));

    wire b_s, busy_s;
    sync2 u_sb (.clk(clk), .d(~sw[1]), .q(b_s));
    sync2 u_sbusy (.clk(clk), .d(~sw[7]), .q(busy_s));

    wire trig, vetoed, busy;
    trigger_logic #(.GATE(4), .DEAD(100_000_000)) u_trig (
        .clk(clk),
        .a(a),
        .b(b_s),
        .busy_in(busy_s),
        .trig(trig),
        .vetoed(vetoed),
        .busy(busy)
    );

    reg t_led = 0, v_led = 0;
    always @(posedge clk) begin
        if (trig)   t_led <= ~t_led;
        if (vetoed) v_led <= ~v_led;
    end

    assign led = ~ {5'b0, v_led, t_led, busy};
    assign tp[0] = trig;
    assign tp[1] = busy;
endmodule