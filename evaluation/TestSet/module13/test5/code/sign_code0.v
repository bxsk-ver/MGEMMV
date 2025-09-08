
module Multi_Booth_signed_even #(
    parameter width=8
)(
    input wire [width:1] A,
    input wire [width:1] B,
    output wire [width*2:1] P
);
    wire [width+1:1] A_expand;
    wire [width/2:1] two;
    wire [width/2:1] neg;
    wire [width/2:1] zero;
    wire [width+1:1] pp [1:width/2];
    wire [width+3:1] pp_expand_first;
    wire [width+2:1] pp_expand_other [1:width/2-1];
    wire [width*2-1:1] P_temp0;
    wire [width*2:1] P_temp1;
    wire [width*2:1] P_temp2;
    wire [14:1] Level_1_1;
    wire [13:1] Level_1_2;
    wire [16:1] Level_1_3;
    wire [16:1] Level_2_1;
    wire [15:1] Level_2_2;

    assign A_expand = {A,1'b0};
    assign P_temp0 = ((~A+1'b1)<<7);
    assign P_temp1 = {P_temp0[width*2-1],P_temp0};
    
    genvar i;
    generate 
        for(i=1; i<width/2+1; i=i+1) begin
            assign two[i] = ~(A_expand[2*i]^A_expand[2*i-1]);
            assign neg[i] = A_expand[2*i+1];
            assign zero[i] = ~(A_expand[2*i+1]|A_expand[2*i]|A_expand[2*i-1])|(A_expand[2*i+1]&A_expand[2*i]&A_expand[2*i-1]);
        end
        for(i=1; i<width/2+1; i=i+1) begin
            assign pp[i] = zero[i] ? {(width+1){1'b0}}: (neg[i] ? (two[i] ? ({~B,1'b1}+1'b1) : ({~B[width],~B}+1'b1)) : (two[i] ? {B,1'b0} : {B[width],B}));
        end
        for(i=1; i<width/2; i=i+1) begin
            assign pp_expand_other[i] = {1'b1,~pp[i+1][width+1],pp[i+1][width:1]};
        end
    endgenerate  
    assign pp_expand_first = {~pp[1][width+1],pp[1][width+1],pp[1]};
    
    CSA_3to2_11_12_14 #(.A_width(11), .B_width(12), .C_width(14)) u1_0 (.A(pp_expand_first),.B({pp_expand_other[1],{2{1'b0}}}),.C({pp_expand_other[2],{4{1'b0}}}),.S(Level_1_1),.Cout(Level_1_2));
    assign Level_1_3 = {pp_expand_other[3],{6{1'b0}}};
    CSA_3to2_14_13_16 #(.A_width(14), .B_width(13), .C_width(16)) u2_0 (.A(Level_1_1),.B(Level_1_2),.C(Level_1_3),.S(Level_2_1),.Cout(Level_2_2));
    PPA_Sklansky_16bit #(.width(16)) u_final (.A(Level_2_1), .B({1'b0, Level_2_2}), .cin(1'b0), .S(P_temp2), .cout());

    assign P = (B==8'b10000000) ? P_temp1 : P_temp2;
endmodule
