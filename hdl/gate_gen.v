`default_nettype none

module gate_gen #( 
    parameter WIDTH = 4
)(
    input wire clk,
    input wire in,
    output wire gate
);
    reg [7:0] cnt = 0;

    always @(posedge clk) begin
        if (in)
            cnt <= WIDTH;
        else if (cnt != 0)
            cnt <= cnt -1;
    end

    assign gate = (cnt != 0);
endmodule