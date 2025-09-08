module C_Sel_A_49bit #(
    parameter width=49
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c32;
    wire c48;

    C_Sel_A_32bit #(.width(32)) u0 (
        .A(A[32:1]),
        .B(B[32:1]),
        .cin(cin),
        .S(S[32:1]),
        .cout(c32)
    );
    C_Sel_A_16bit #(.width(16)) u1 (
        .A(A[48:33]),
        .B(B[48:33]),
        .cin(c32),
        .S(S[48:33]),
        .cout(c48)
    );
    C_Sel_A_1bit #(.width(1)) u2 (
        .A(A[49:49]),
        .B(B[49:49]),
        .cin(c48),
        .S(S[49:49]),
        .cout(cout)
    );

endmodule
