`default_nettype none

module top (
    input  wire         clk,
    input  wire         btn_n,
    input  wire [7:0]   sw,
    output wire [7:0]   led,
    output wire [1:0]   tp
);

    wire btn_s, btn_db, p_raw, p_db;

    sync2                u_sync  (.clk(clk), .d(~btn_n), .q(btn_s));
    debounce #(.N(20))   u_db    (.clk(clk), .d(btn_s), .q(btn_db));
    rise_detect          u_r1    (.clk(clk), .d(btn_s), .pulse(p_raw));
    rise_detect          u_r2    (.clk(clk), .d(btn_db), .pulse(p_db));

    // When SW3-1 (on your board) is ON, activate debounce
    wire pulse = (sw[0] == 1'b0) ? p_db : p_raw;

    reg[7:0] cnt = 0;
    always @(posedge clk) begin
        if (pulse) cnt <= cnt +1;
    end
    assign led = ~cnt;

    assign tp[0] = pulse;
    assign tp[1] = btn_s;

endmodule