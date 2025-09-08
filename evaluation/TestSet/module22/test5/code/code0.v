
module Wino_ATZA_22_21_golden#(
    parameter data_width = 20
)(
    // din = 3 * 2
    input [data_width - 1:0] din0, din1, din2, din3, din4, din5,
    // dout = AT * dout * A
    output [data_width - 1:0] dout0, dout1, dout2, dout3
);

    // temp0 = AT * din
    wire [data_width - 1:0] temp0_0, temp0_1, temp0_2, temp0_3;

    assign temp0_0 = din0 + din2;
    assign temp0_1 = din1 + din3;
    assign temp0_2 = din0 - din2 + din4;
    assign temp0_3 = din1 - din3 + din5;

    // dout = temp0 * A
    assign dout0 = temp0_0;
    assign dout1 = temp0_1;
    assign dout2 = temp0_2;
    assign dout3 = temp0_3;

endmodule
