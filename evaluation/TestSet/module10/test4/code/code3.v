module CLA_8bit #(
    parameter width=8
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_8,
    output wire g_1_8
);

    wire c4;
    wire p_1_4, g_1_4;
    wire p_5_8, g_5_8;

    CLA_4bit #(.width(4)) u0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .cin(cin),
        .S(S[4:1]),
        .cout(c4),
        .p_1_4(p_1_4),
        .g_1_4(g_1_4)
    );
    CLA_4bit #(.width(4)) u1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .cin(c4),
        .S(S[8:5]),
        .cout(cout),
        .p_1_4(p_5_8),
        .g_1_4(g_5_8)
    );
    assign p_1_8 = p_1_4 & p_5_8;
    assign g_1_8 = g_5_8|(g_1_4&p_5_8);
endmodule
