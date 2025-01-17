// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_row (clk, out_s, in_w, in_n, valid, inst_w, zero_flag, reset);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  output [col-1:0] valid;
  input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  input zero_flag;

  wire  [(col+1)*bw-1:0] temp;
  wire  [(col+1)*2-1:0] inst_temp;
  wire [col:0] zero_temp; 

  assign temp[bw-1:0]   = in_w;
  assign inst_temp [1:0] = inst_w;
  assign zero_temp[0] = zero_flag;
  genvar i;
  for (i=1; i < col+1 ; i=i+1) begin : col_num
      mac_tile #(.bw(bw), .psum_bw(psum_bw)) mac_tile_instance (
        .clk(clk),
        .reset(reset),
	    .in_w( temp[bw*i-1:bw*(i-1)]),
	    .out_e(temp[bw*(i+1)-1:bw*i]),
	    .inst_w(inst_temp[2*i-1:2*(i-1)]),
      .zero_flag_w(zero_temp[i-1]),
      .zero_flag_e(zero_temp[i]),
	    .inst_e(inst_temp[2*(i+1)-1:2*i]),
	    .in_n(in_n[psum_bw*i-1:psum_bw*(i-1)]),
	    .out_s(out_s[psum_bw*i-1:psum_bw*(i-1)])
    );
    assign valid[i-1] = inst_temp[2*(i)-1];
  end

endmodule
