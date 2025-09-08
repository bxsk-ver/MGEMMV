module GP_Gen_1_7 #(
    parameter width=7
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_5_7, p_5_6, p_5_5;
    wire g_5_7, g_5_6, g_5_5;
    GP_Gen_1_4 #(.width(4)) u0 (.p(p[4:1]), .g(g[4:1]), .P(P[4:1]), .G(G[4:1]));
    GP_Gen_1_3 #(.width(3)) u1 (.p(p[7:5]), .g(g[7:5]), .P({p_5_7, p_5_6, p_5_5}), .G({g_5_7, g_5_6, g_5_5}));
    assign P[5] = P[4] & p_5_5;
    assign G[5] = g_5_5 | (G[4] & p_5_5);
    assign P[6] = P[4] & p_5_6;
    assign G[6] = g_5_6 | (G[4] & p_5_6);
    assign P[7] = P[4] & p_5_7;
    assign G[7] = g_5_7 | (G[4] & p_5_7);

endmodule
