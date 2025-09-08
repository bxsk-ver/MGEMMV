module CLA_1bit #(
    parameter width=1
) (
    input wire A,
    input wire B,
    input wire cin,
    output wire S,
    output wire cout,
    output wire p_1_1,
    output wire g_1_1
);
    wire p, g;
    assign p = A ^ B;
    assign g = A & B;
    GP_Gen_1_1 #(.width(width)) u0 (.p(p), .g(g), .cin(cin), .cout(cout), .p_1_1(p_1_1), .g_1_1(g_1_1));
    assign S = cin ^ p;
endmodule
