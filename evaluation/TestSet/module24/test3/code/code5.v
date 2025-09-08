module C_Sel_A_32bit #(
    parameter width=32
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c16;

    C_Sel_A_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16)
    );
    C_Sel_A_16bit #(.width(16)) u1 (
        .A(A[32:17]),
        .B(B[32:17]),
        .cin(c16),
        .S(S[32:17]),
        .cout(cout)
    );

endmodule
