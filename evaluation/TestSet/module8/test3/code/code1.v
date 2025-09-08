module C_Skip_A_26bit #(
    parameter width=26
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout
);

    wire c16;
    wire c24;

    C_Skip_A_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16)
    );
    C_Skip_A_8bit #(.width(8)) u1 (
        .A(A[24:17]),
        .B(B[24:17]),
        .cin(c16),
        .S(S[24:17]),
        .cout(c24)
    );
    C_Skip_A_2bit #(.width(2)) u2 (
        .A(A[26:25]),
        .B(B[26:25]),
        .cin(c24),
        .S(S[26:25]),
        .cout(cout)
    );

endmodule
