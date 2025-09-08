module GP_Gen_1_6 #(
    parameter width=6
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_5_6, p_5_5;
    wire g_5_6, g_5_5;
    GP_Gen_1_4 #(.width(4)) u0 (.p(p[4:1]), .g(g[4:1]), .P(P[4:1]), .G(G[4:1]));
    GP_Gen_1_2 #(.width(2)) u1 (.p(p[6:5]), .g(g[6:5]), .P({p_5_6, p_5_5}), .G({g_5_6, g_5_5}));
    assign P[5] = P[4] & p_5_5;
    assign G[5] = g_5_5 | (G[4] & p_5_5);
    assign P[6] = P[4] & p_5_6;
    assign G[6] = g_5_6 | (G[4] & p_5_6);

endmodule
