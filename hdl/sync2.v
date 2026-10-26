`default_nettype none

module sync2 (
    input wire clk,
    input wire d,
    output wire q
);

    reg s1 = 0, s2 = 0;

    always @(posedge clk) begin
        s1 <= d;
        s2 <= s1;
    end

    assign q = s2;
endmodule