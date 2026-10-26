`default_nettype none

module button_pulse #(
    parameter N = 20
)(
    input wire clk,
    input wire btn_n,
    output wire pulse
);
    wire s, db;
    sync2             u_sync    (.clk(clk), .d(~btn_n), .q(s));
    debounce #(.N(N)) u_db      (.clk(clk), .d(s),      .q(db));
    rise_detect       u_rd      (.clk(clk), .d(db),     .pulse(pulse));
endmodule