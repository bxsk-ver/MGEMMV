module CLA_25bit #(
    parameter width=25
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_25,
    output wire g_1_25
);

    wire c16;
    wire c24;
    wire p_1_16, g_1_16;
    wire p_17_24, g_17_24;
    wire p_25_25, g_25_25;

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
    CLA_1bit #(.width(1)) u2 (
        .A(A[25:25]),
        .B(B[25:25]),
        .cin(c24),
        .S(S[25:25]),
        .cout(cout),
        .p_1_1(p_25_25),
        .g_1_1(g_25_25)
    );
    assign p_1_25 = p_1_16 & p_17_24 & p_25_25;
    assign g_1_25 = g_25_25|(g_17_24&p_25_25)|(g_1_16&p_17_24&p_25_25);
endmodule
