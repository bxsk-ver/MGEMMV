module CLA_4bit #(
    parameter width=4
) (
    input wire [width:1] A,
    input wire [width:1] B,
    input wire cin,
    output wire [width:1] S,
    output wire cout,
    output wire p_1_4,
    output wire g_1_4
);
    wire [width:1] p, g;
    wire [width:0] c_temp;
    assign c_temp[0] = cin;
    assign p = A ^ B;
    assign g = A & B;
    GP_Gen_1_4 #(.width(width)) u0 (.p(p), .g(g), .cin(c_temp[0]), .cout(c_temp[width:1]), .p_1_4(p_1_4), .g_1_4(g_1_4));
    assign S = c_temp[width-1:0] ^ p;
    assign cout = c_temp[width];
endmodule
