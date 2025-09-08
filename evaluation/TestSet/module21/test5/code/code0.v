
module DataReOrganize_golden#(
    parameter data_width = 22,
    parameter  a_tile_column_size = 6
    )(
    // interface to system
    input wire clk,                         
    input wire rst_n,                   
    input wire en, 
    input wire [data_width * a_tile_column_size - 1 : 0] din,
    output reg [data_width * a_tile_column_size - 1 : 0] dout
    );
    reg [data_width - 1 : 0] row0_delay;
    reg [data_width * 2 - 1 : 0] row1_delay;
    reg [data_width * 3 - 1 : 0] row2_delay;
    reg [data_width * 4 - 1 : 0] row3_delay;
    reg [data_width * 5 - 1 : 0] row4_delay;
    reg [data_width * 6 - 1 : 0] row5_delay;

// Always block for reset and functionality
    always @(negedge rst_n or posedge clk) begin
        if (~rst_n) begin
            row0_delay <= 'd0;
            row1_delay <= 'd0;
            row2_delay <= 'd0;
            row3_delay <= 'd0;
            row4_delay <= 'd0;
            row5_delay <= 'd0;
        end else if (en) begin
            // input -> array
            row0_delay [data_width - 1 : 0] <= din [data_width * 1 - 1 : data_width * 0];
            row1_delay [data_width - 1 : 0] <= din [data_width * 2 - 1 : data_width * 1];
            row2_delay [data_width - 1 : 0] <= din [data_width * 3 - 1 : data_width * 2];
            row3_delay [data_width - 1 : 0] <= din [data_width * 4 - 1 : data_width * 3];
            row4_delay [data_width - 1 : 0] <= din [data_width * 5 - 1 : data_width * 4];
            row5_delay [data_width - 1 : 0] <= din [data_width * 6 - 1 : data_width * 5];

            // array flow
            row1_delay [data_width * 2 - 1 : data_width] <= row0_delay [data_width * 1 - 1 : 0];
            row2_delay [data_width * 3 - 1 : data_width] <= row1_delay [data_width * 2 - 1 : 0];
            row3_delay [data_width * 4 - 1 : data_width] <= row2_delay [data_width * 3 - 1 : 0];
            row4_delay [data_width * 5 - 1 : data_width] <= row3_delay [data_width * 4 - 1 : 0];
            row5_delay [data_width * 6 - 1 : data_width] <= row4_delay [data_width * 5 - 1 : 0];

            // array -> output
            dout [data_width * 1 - 1 : data_width * 0] <= row0_delay [data_width * 1 - 1 : data_width * 0];
            dout [data_width * 2 - 1 : data_width * 1] <= row1_delay [data_width * 2 - 1 : data_width * 1];
            dout [data_width * 3 - 1 : data_width * 2] <= row2_delay [data_width * 3 - 1 : data_width * 2];
            dout [data_width * 4 - 1 : data_width * 3] <= row3_delay [data_width * 4 - 1 : data_width * 3];
            dout [data_width * 5 - 1 : data_width * 4] <= row4_delay [data_width * 5 - 1 : data_width * 4];
            dout [data_width * 6 - 1 : data_width * 5] <= row5_delay [data_width * 6 - 1 : data_width * 5];
        end
    end
endmodule
