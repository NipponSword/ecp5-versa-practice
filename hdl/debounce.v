module debounce #(
    parameter N = 20   
)(
    input wire clk,
    input wire d,
    output reg q = 0
);
    reg [N-1:0] cnt = 0;

    always @(posedge clk) begin
        if (d == q) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
            if (&cnt) begin
                q <= d;
                cnt <= 0;
            end
        end
    end
endmodule