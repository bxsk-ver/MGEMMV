module C_Skip_A_8bit #(
    parameter width=8
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c4;

    C_Skip_A_4bit #(.width(4)) u0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .cin(cin),
        .S(S[4:1]),
        .cout(c4)
    );
    C_Skip_A_4bit #(.width(4)) u1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .cin(c4),
        .S(S[8:5]),
        .cout(cout)
    );

endmodule
