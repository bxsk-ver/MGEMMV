
module Wino_BTDB_22_23_golden#(
    parameter data_width = 18
    )
    (
    // din = 3 * 4
    input wire [data_width - 1 : 0] din0,  din1,  din2,  din3, din4,  din5,  din6,  din7, din8,  din9,  din10, din11,
    // dout = BT * D * B
    output wire [data_width - 1 : 0] dout0,  dout1,  dout2,  dout3, dout4,  dout5,  dout6,  dout7, dout8,  dout9,  dout10, dout11
    );

    wire [data_width - 1:0] temp0_0,  temp0_1,  temp0_2,  temp0_3;
    wire [data_width - 1:0] temp0_4,  temp0_5,  temp0_6,  temp0_7;
    wire [data_width - 1:0] temp0_8,  temp0_9,  temp0_10, temp0_11;

    // temp0 = BT * D
    assign temp0_0  = din0 + din4;
    assign temp0_1  = din1 + din5;
    assign temp0_2  = din2 + din6;
    assign temp0_3  = din3 + din7;
    
    assign temp0_4  = din4 - din0;
    assign temp0_5  = din5 - din1;
    assign temp0_6  = din6 - din2;
    assign temp0_7  = din7 - din3;
    
    assign temp0_8  = din8  - din0;
    assign temp0_9  = din9  - din1;
    assign temp0_10 = din10 - din2;
    assign temp0_11 = din11 - din3;

    // dout = temp0 * B
    assign dout0  = temp0_0 - temp0_2;
    assign dout1  = temp0_1 + temp0_2;
    assign dout2  = temp0_2 - temp0_1;
    assign dout3  = temp0_1 - temp0_3;
    
    assign dout4  = temp0_4 - temp0_6;
    assign dout5  = temp0_5 + temp0_6;
    assign dout6  = temp0_6 - temp0_5;
    assign dout7  = temp0_5 - temp0_7;
    
    assign dout8  = temp0_8  - temp0_10;
    assign dout9  = temp0_9  + temp0_10;
    assign dout10 = temp0_10 - temp0_9;
    assign dout11 = temp0_9  - temp0_11;

endmodule

