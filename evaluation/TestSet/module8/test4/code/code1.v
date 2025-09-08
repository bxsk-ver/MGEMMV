module CLA_23bit #(
    parameter width=23
)(
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_23,
    output wire g_1_23
);

    wire c16;
    wire c20;
    wire p_1_16, g_1_16;
    wire p_17_20, g_17_20;
    wire p_21_23, g_21_23;

    CLA_16bit #(.width(16)) u0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(cin),
        .S(S[16:1]),
        .cout(c16),
        .p_1_16(p_1_16),
        .g_1_16(g_1_16)
    );
    CLA_4bit #(.width(4)) u1 (
        .A(A[20:17]),
        .B(B[20:17]),
        .cin(c16),
        .S(S[20:17]),
        .cout(c20),
        .p_1_4(p_17_20),
        .g_1_4(g_17_20)
    );
    CLA_3bit #(.width(3)) u2 (
        .A(A[23:21]),
        .B(B[23:21]),
        .cin(c20),
        .S(S[23:21]),
        .cout(cout),
        .p_1_3(p_21_23),
        .g_1_3(g_21_23)
    );
    assign p_1_23 = p_1_16 & p_17_20 & p_21_23;
    assign g_1_23 = g_21_23|(g_17_20&p_21_23)|(g_1_16&p_17_20&p_21_23);
endmodule
