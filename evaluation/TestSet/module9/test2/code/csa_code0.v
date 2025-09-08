
module CSA_3to2_17_17_17 #(
    parameter A_width=17,
    parameter B_width=17,
    parameter C_width=17
)(
    input wire [A_width:1] A,
    input wire [B_width:1] B,
    input wire [C_width:1] C,
    output wire [C_width:1] S,
    output wire [B_width+1:1] Cout
);
    genvar i;
    generate
        for (i=1; i<C_width+1; i=i+1) begin
            assign {Cout[i+1], S[i]} = A[i] + B[i] + C[i];
        end
    endgenerate
    assign Cout[1] = 1'b0;
endmodule
