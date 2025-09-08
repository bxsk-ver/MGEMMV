
module PE_golden#(
    parameter data_width = 18
    )
    (
    input wire clk,                         
    input wire rst_n,                 
    input wire w_en,
    input wire w_compute,     
    input wire [data_width - 1 : 0] active_left,
    output reg [data_width - 1 : 0] active_right,

    input wire [data_width * 2 - 1 : 0] in_sum,
    output reg [data_width * 2 - 1 : 0] out_sum,

    input wire [data_width - 1 : 0] in_weight_above,
    output reg [data_width - 1 : 0] out_weight_below
	);

	always @(negedge rst_n or posedge clk) begin
        if(~rst_n) begin
            out_weight_below <= {data_width {1'b0}};
            active_right <= {data_width {1'b0}};
            out_sum <= {data_width * 2 {1'b0}};
        end else if (w_en) begin
            out_weight_below <= in_weight_above;
        end else if (w_compute) begin 
            active_right <= active_left;
            out_sum <= out_weight_below * active_left + in_sum;
        end
    end
endmodule
