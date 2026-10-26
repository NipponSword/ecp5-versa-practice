module rise_detect (
    input wire clk,
    input wire d,
    output wire pulse
);

    reg d_prev = 0;

    always @(posedge clk) begin
        d_prev <=d;
    end

    assign pulse = d & ~d_prev;
endmodule