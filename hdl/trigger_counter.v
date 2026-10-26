`default_nettype none

module trig_counter (
    input wire clk,
    input wire clr,
    input wire trig,
    input wire vetoed,
    output reg [15:0] n_trig = 0,
    output reg [15:0] n_veto = 0
);
    always @(posedge clk) begin
        if (clr) begin
            n_trig <= 0;
            n_veto <= 0;
        end else begin
            if (trig)   n_trig <= n_trig + 1;
            if (vetoed) n_veto <= n_veto + 1;
        end
    end
endmodule