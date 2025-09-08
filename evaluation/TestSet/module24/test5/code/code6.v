module C_Sel_A_1bit #(
    parameter width=1
) (
    input wire A,
    input wire B,
    input wire cin,
    output wire S,
    output wire cout
);
    wire S0, S1;
    wire cout0, cout1;
    assign {cout0, S0} = A + B + 1'b0;
    assign {cout1, S1} = A + B + 1'b1;
    assign S = cin ? S1 : S0;
    assign cout = cin ? cout1 : cout0;
endmodule
