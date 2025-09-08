
module PE_array_golden#(
    parameter data_width = 19,
    parameter  a_tile_row_size = 14,
    parameter  w_tile_column_size = 2
    )
	(
	// interface to system
    input wire clk,                         
    input wire rst_n,                  
    input wire w_en,  
    input wire w_compute,
	input wire [data_width * a_tile_row_size - 1 : 0] active_left,
    output wire [data_width * a_tile_row_size - 1 : 0] active_right,
	input wire [data_width * w_tile_column_size - 1 : 0] in_weight_above,
	output wire [data_width * w_tile_column_size - 1 : 0] out_weight_below,
	input wire [data_width * 2 * w_tile_column_size - 1 : 0]  in_sum,
	output wire [data_width * 2 * w_tile_column_size - 1 : 0]  out_sum
	);

	wire [data_width * w_tile_column_size * (a_tile_row_size + 1) - 1 : 0] out_weight_below_temp;
    wire [data_width * 2 * w_tile_column_size * (a_tile_row_size + 1) - 1 : 0] out_sum_temp;

    assign out_weight_below_temp [data_width * w_tile_column_size - 1 : 0] = in_weight_above;
    assign out_sum_temp [data_width * 2 * w_tile_column_size - 1 : 0] = in_sum;

    genvar i;
    generate
        for(i = a_tile_row_size - 1; i >= 0; i = i - 1) begin
            PE_row #(
            .data_width(data_width),
            .w_tile_column_size(w_tile_column_size)
            )
            PE_row_unit(
            .clk(clk),
            .rst_n(rst_n),
            .w_en(w_en),
            .w_compute(w_compute),
            .active_left(active_left[(i+1) * data_width - 1 : i * data_width]),
            .active_right(active_right[(i+1) * data_width - 1 : i * data_width]),
            .in_sum(out_sum_temp[(i+1) * data_width * 2 * w_tile_column_size - 1 : i * data_width * 2 * w_tile_column_size]),
            .out_sum(out_sum_temp[(i+2) * data_width * 2 * w_tile_column_size - 1 : (i+1) * data_width * 2 * w_tile_column_size]),
            .in_weight_above(out_weight_below_temp[(i+1) * data_width * w_tile_column_size - 1 : i * data_width * w_tile_column_size]),
            .out_weight_below(out_weight_below_temp[(i+2) * data_width * w_tile_column_size - 1 : (i+1) * data_width * w_tile_column_size])
            );
        end
    endgenerate
    assign out_weight_below = out_weight_below_temp [data_width * w_tile_column_size * (a_tile_row_size + 1) - 1 : data_width * w_tile_column_size * a_tile_row_size];
    assign out_sum = out_sum_temp [data_width * 2 * w_tile_column_size * (a_tile_row_size + 1) - 1 : data_width * 2 * w_tile_column_size * a_tile_row_size];
endmodule
