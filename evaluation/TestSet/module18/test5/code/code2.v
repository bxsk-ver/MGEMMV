module FA_12bit #(
    parameter width=12
) (
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);
    wire [width:0] c_temp;
    assign c_temp[0] = cin;
    genvar i;
    generate
        for (i=1; i<width+1; i=i+1) begin
            FA_1bit #(.width(1)) u0 (.A(A[i]), .B(B[i]), .cin(c_temp[i-1]), .S(S[i]), .cout(c_temp[i]));
        end
    endgenerate
    assign cout = c_temp[width];
endmodule
