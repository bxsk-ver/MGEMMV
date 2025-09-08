module GP_Gen_1_3 #(
    parameter width=3
)(
    input wire [width:1] p,
    input wire [width:1] g,
    input wire cin,
    output wire [width:1] cout,
    output wire p_1_3,
    output wire g_1_3
);

    wire g_1_1, g_1_2;
    wire p_1_1, p_1_2;
    assign p_1_1 = p[1];
    assign g_1_1 = g[1];
    assign p_1_2 = p[1]&p[2];
    assign g_1_2 = g[2]|(g[1]&p[2]);
    assign p_1_3 = p[1]&p[2]&p[3];
    assign g_1_3 = g[3]|(g[2]&p[3])|(g[1]&p[2]&p[3]);
    assign cout[1] = g_1_1 | (p_1_1 & cin);
    assign cout[2] = g_1_2 | (p_1_2 & cin);
    assign cout[3] = g_1_3 | (p_1_3 & cin);
endmodule
