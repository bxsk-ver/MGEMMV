module GP_Gen_1_4 #(
    parameter width=4
)( 
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
);
    wire p_3_4, p_3_3;
    wire g_3_4, g_3_3;
    GP_Gen_1_2 #(.width(2)) u0 (.p(p[2:1]), .g(g[2:1]), .P(P[2:1]), .G(G[2:1]));
    GP_Gen_1_2 #(.width(2)) u1 (.p(p[4:3]), .g(g[4:3]), .P({p_3_4, p_3_3}), .G({g_3_4, g_3_3}));
    assign P[3] = P[2] & p_3_3;
    assign G[3] = g_3_3 | (G[2] & p_3_3);
    assign P[4] = P[2] & p_3_4;
    assign G[4] = g_3_4 | (G[2] & p_3_4);

endmodule
