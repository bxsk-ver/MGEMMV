
module GP_Gen_1_19 #(
    parameter width=19 
    )(
    input wire [width:1] p,
    input wire [width:1] g,
    output wire [width:1] P,
    output wire [width:1] G
    );
    wire [width:1] P_L1, G_L1;
    wire [width:1] P_L2, G_L2;
    wire [width:1] P_L3, G_L3;
    wire [width:1] P_L4, G_L4;
    genvar i1, i2, i3, i4, i5;
    genvar j1, j2, j3, j4, j5;
    generate
        for (j1=1; j1<2; j1=j1+1) begin
            assign P_L1[j1] = p[j1];
            assign G_L1[j1] = g[j1];
        end
        for (i1=1; i1<width; i1=i1+1) begin
            assign P_L1[i1+1] = p[i1] & p[i1+1];
            assign G_L1[i1+1] = g[i1+1] | (g[i1] & p[i1+1]);
        end
        for (j2=1; j2<3; j2=j2+1) begin
            assign P_L2[j2] = P_L1[j2];
            assign G_L2[j2] = G_L1[j2];
        end
        for (i2=1; i2<width-1; i2=i2+1) begin
            assign P_L2[i2+2] = P_L1[i2] & P_L1[i2+2];
            assign G_L2[i2+2] = G_L1[i2+2] | (G_L1[i2] & P_L1[i2+2]);
        end
        for (j3=1; j3<5; j3=j3+1) begin
            assign P_L3[j3] = P_L2[j3];
            assign G_L3[j3] = G_L2[j3];
        end
        for (i3=1; i3<width-3; i3=i3+1) begin
            assign P_L3[i3+4] = P_L2[i3] & P_L2[i3+4];
            assign G_L3[i3+4] = G_L2[i3+4] | (G_L2[i3] & P_L2[i3+4]);
        end
        for (j4=1; j4<9; j4=j4+1) begin
            assign P_L4[j4] = P_L3[j4];
            assign G_L4[j4] = G_L3[j4];
        end
        for (i4=1; i4<width-7; i4=i4+1) begin
            assign P_L4[i4+8] = P_L3[i4] & P_L3[i4+8];
            assign G_L4[i4+8] = G_L3[i4+8] | (G_L3[i4] & P_L3[i4+8]);
        end
        for (j5=1; j5<17; j5=j5+1) begin
            assign P[j5] = P_L4[j5];
            assign G[j5] = G_L4[j5];
        end
        for (i5=1; i5<width-15; i5=i5+1) begin
            assign P[i5+16] = P_L4[i5] & P_L4[i5+16];
            assign G[i5+16] = G_L4[i5+16] | (G_L4[i5] & P_L4[i5+16]);
        end
    endgenerate
endmodule