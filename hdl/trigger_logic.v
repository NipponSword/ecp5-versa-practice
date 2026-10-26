`default_nettype none

module trigger_logic #(
    parameter GATE = 4,
    parameter DEAD = 50  // self-busy width
)(
    input wire clk,
    input wire a,
    input wire b,
    input wire busy_in,
    output wire trig,
    output wire vetoed,
    output wire busy
);

    wire ga, gb;
    gate_gen #(.WIDTH(GATE)) u_ga (.clk(clk), .in(a), .gate(ga));
    gate_gen #(.WIDTH(GATE)) u_gb (.clk(clk), .in(b), .gate(gb));

    wire coin = ga & gb;
    wire coin_p;
    rise_detect u_rd (.clk(clk), .d(coin), .pulse(coin_p));

    reg [31:0] dead_cnt = 0;
    wire busy_self = (dead_cnt != 0);
    assign busy = busy_self | busy_in;

    assign trig     = coin_p & ~busy;
    assign vetoed   = coin_p &  busy;

    always @(posedge clk) begin
        if (trig)
            dead_cnt <= DEAD;
        else if (dead_cnt != 0)
            dead_cnt <= dead_cnt - 1;
    end
endmodule