module blink #(
    parameter W = 30
)(
    input wire clk,
    output wire [7:0] led
);

    reg [W-1:0] cnt = 0;

    always @(posedge clk) begin
        cnt <= cnt + 1;
    end

    assign led = ~cnt[W-1:W-8];
    // assign led = ~ {8{cnt[26]}};
endmodule