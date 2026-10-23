module counter4 (
    input wire clk,
    input wire en,
    output wire [3:0] q
);

    reg [3:0] cnt = 0;

    always @(posedge clk) begin
        if (en) begin
            cnt <= cnt + 1;
        end
    end

    assign q = cnt;
endmodule