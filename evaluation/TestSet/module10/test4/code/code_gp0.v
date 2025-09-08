module GP_Gen_1_4 #(
    parameter width=4
)(
    input wire [width:1] p,
    input wire [width:1] g,
    input wire cin,
    output wire [width:1] cout,
    output wire p_1_4,
    output wire g_1_4
);

    wire g_1_1, g_1_2, g_1_3;
    wire p_1_1, p_1_2, p_1_3;
    assign p_1_1 = p[1];
    assign g_1_1 = g[1];
    assign p_1_2 = p[1]&p[2];
    assign g_1_2 = g[2]|(g[1]&p[2]);
    assign p_1_3 = p[1]&p[2]&p[3];
    assign g_1_3 = g[3]|(g[2]&p[3])|(g[1]&p[2]&p[3]);
    assign p_1_4 = p[1]&p[2]&p[3]&p[4];
    assign g_1_4 = g[4]|(g[3]&p[4])|(g[2]&p[3]&p[4])|(g[1]&p[2]&p[3]&p[4]);
    assign cout[1] = g_1_1 | (p_1_1 & cin);
    assign cout[2] = g_1_2 | (p_1_2 & cin);
    assign cout[3] = g_1_3 | (p_1_3 & cin);
    assign cout[4] = g_1_4 | (p_1_4 & cin);
endmodule
