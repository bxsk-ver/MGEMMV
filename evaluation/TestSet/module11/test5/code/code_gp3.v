module GP_Gen_1_1 #(
    parameter width=1
) (
    input wire p,
    input wire g,
    input wire cin,
    output wire cout,
    output wire p_1_1,
    output wire g_1_1
);

    assign p_1_1 = p;
    assign g_1_1 = g;
    assign cout = g_1_1 | (p_1_1 & cin);
endmodule
