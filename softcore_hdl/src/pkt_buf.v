// 128 bytes
`define PKT_DIM_BASE 2
`define PKT_DIM_EXP  4

module pkt_buf (
		clk,
		rst,
		load,
		pkt_off,
		byte_count,
		data_in,
		data_out);

  input clk;
  input wire rst;
  input wire load;
  input wire [63:0] pkt_off; // src + imm
  
  // Byte count encoding:
  // 00: b, 01: hw, 10: w, 11: dw
  input wire [1:0]  byte_count;
  
  input wire [(`PKT_DIM_BASE**`PKT_DIM_EXP)*64 - 1:0] data_in;  // 128 bytes input bus
  output reg [63:0] 				      data_out; // 64 bits output bus
  
  // memory definition
  reg [(`PKT_DIM_BASE**`PKT_DIM_EXP)*64 - 1 : 0] memory;

  always @ (byte_count, pkt_off) begin
    case (byte_count)
      2'b00: data_out   <= memory[pkt_off +: 8];
      2'b01: data_out   <= memory[pkt_off +: 16];
      2'b10: data_out   <= memory[pkt_off +: 32];
      2'b11: data_out   <= memory[pkt_off +: 64];
      default: data_out <= 64'bx;
    endcase // case (byte_count)
  end // always @ (byte_count, pkt_off)
  
  
  always @ (posedge clk) begin
    if (rst) begin
      memory <= {1016'h0,8'hff};
    end
    else begin
      if (load) begin
	memory <= data_in;
      end
    end
  end // always @ (posedge clk)
  
endmodule // pkt_buf

      
