module C_Skip_A_1bit #(
    parameter width=1
) (
    input wire A,
    input wire B,
    input wire cin,
    output wire S,
    output wire cout
);
    wire p, cout_fa;
    assign p = A ^ B;
    assign {cout_fa, S} = A + B + cin;
    assign cout = p ? cin : cout_fa;
endmodule
