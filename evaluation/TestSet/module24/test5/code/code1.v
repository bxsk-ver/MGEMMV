module C_Sel_A_45bit #(
    parameter width=45
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c32;
    wire c40;
    wire c44;

    C_Sel_A_32bit #(.width(32)) u0 (
        .A(A[32:1]),
        .B(B[32:1]),
        .cin(cin),
        .S(S[32:1]),
        .cout(c32)
    );
    C_Sel_A_8bit #(.width(8)) u1 (
        .A(A[40:33]),
        .B(B[40:33]),
        .cin(c32),
        .S(S[40:33]),
        .cout(c40)
    );
    C_Sel_A_4bit #(.width(4)) u2 (
        .A(A[44:41]),
        .B(B[44:41]),
        .cin(c40),
        .S(S[44:41]),
        .cout(c44)
    );
    C_Sel_A_1bit #(.width(1)) u3 (
        .A(A[45:45]),
        .B(B[45:45]),
        .cin(c44),
        .S(S[45:45]),
        .cout(cout)
    );

endmodule
