
module Wino_ATZA_22_31_golden#(
    parameter data_width = 19
)(
    // din = 4 * 2
    input [data_width - 1:0] din0, din1, din2, din3, din4, din5, din6, din7,
    // dout = AT * dout * A
    output [data_width - 1:0] dout0, dout1, dout2, dout3
);

    // temp0 = AT * din
    wire [data_width - 1:0] temp0_0, temp0_1, temp0_2, temp0_3;

    assign temp0_0 = din0 + din2 + din4;
    assign temp0_1 = din1 + din3 + din7;
    assign temp0_2 = din2 - din4 - din6;
    assign temp0_3 = din3 - din5 - din7;

    // dout = temp0 * A
    assign dout0 = temp0_0;
    assign dout1 = temp0_1;
    assign dout2 = temp0_2;
    assign dout3 = temp0_3;

endmodule
