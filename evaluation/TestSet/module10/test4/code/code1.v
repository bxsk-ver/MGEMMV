module CLA_27bit #(
    parameter width=27
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_27,
    output wire g_1_27
);

    wire c16;
    wire c24;
    wire p_1_16, g_1_16;
    wire p_17_24, g_17_24;
    wire p_25_27, g_25_27;

    CLA_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16),
        .p_1_16(p_1_16),
        .g_1_16(g_1_16)
    );
    CLA_8bit #(.width(8)) u1 (
        .A(A[24:17]),
        .B(B[24:17]),
        .cin(c16),
        .S(S[24:17]),
        .cout(c24),
        .p_1_8(p_17_24),
        .g_1_8(g_17_24)
    );
    CLA_3bit #(.width(3)) u2 (
        .A(A[27:25]),
        .B(B[27:25]),
        .cin(c24),
        .S(S[27:25]),
        .cout(cout),
        .p_1_3(p_25_27),
        .g_1_3(g_25_27)
    );
    assign p_1_27 = p_1_16 & p_17_24 & p_25_27;
    assign g_1_27 = g_25_27|(g_17_24&p_25_27)|(g_1_16&p_17_24&p_25_27);
endmodule
