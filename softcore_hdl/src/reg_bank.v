`define MSB_MASK 64'h00000000ffffffff

module reg_bank(
		clk,
		en,
		rst,
		src_out,
		dst_out,
		src_addr,
		dst_addr,
		dst_in_slc,
		alu_z_out,
		pkt_buf_data_out,
		ram_data_out,
		imm_bus,
		rw,
		zeroout,
		debug_r1,
		debug_r4);

  input clk;
  input wire rst;
  input wire en;
  output reg [63:0] src_out;
  output reg [63:0] dst_out;
  output reg [63:0] debug_r1;
  output reg [63:0] debug_r4;
  input wire [3:0] 	src_addr;
  input wire [3:0] 	dst_addr;
  input wire [1:0] 	dst_in_slc;
  input wire [63:0] 	alu_z_out;
  input wire [63:0] 	pkt_buf_data_out;
  input wire [63:0] 	ram_data_out;
  input wire [63:0] 	imm_bus;
  input wire	rw;
  input wire	zeroout;

  wire [63:0] 	dst_in;
 
  reg [63:0] 	R0;
  reg [63:0] 	R1;
  reg [63:0] 	R2;
  reg [63:0] 	R3;
  reg [63:0] 	R4;
  reg [63:0] 	R5;
  reg [63:0] 	R6;
  reg [63:0] 	R7;
  reg [63:0] 	R8;
  reg [63:0] 	R9;
  reg [63:0] 	R10;

  assign dst_in  = (dst_in_slc == 2'b00) ? alu_z_out
		   : (dst_in_slc == 2'b01) ? pkt_buf_data_out
		   : (dst_in_slc == 2'b10) ? imm_bus
		   : ram_data_out;
  
  
  always @(*) begin 
    case (src_addr)
      4'b0000: src_out  = zeroout ? (R0 & `MSB_MASK) : R0;
      4'b0001: src_out  = zeroout ? (R1 & `MSB_MASK) : R1; 
      4'b0010: src_out  = zeroout ? (R2 & `MSB_MASK) : R2; 
      4'b0011: src_out  = zeroout ? (R3 & `MSB_MASK) : R3;
      4'b0100: src_out  = zeroout ? (R4 & `MSB_MASK) : R4;
      4'b0101: src_out  = zeroout ? (R5 & `MSB_MASK) : R5;
      4'b0110: src_out  = zeroout ? (R6 & `MSB_MASK) : R6;
      4'b0111: src_out  = zeroout ? (R7 & `MSB_MASK) : R7;
      4'b1000: src_out  = zeroout ? (R8 & `MSB_MASK) : R8;
      4'b1001: src_out  = zeroout ? (R9 & `MSB_MASK) : R9;
      4'b1010: src_out  = zeroout ? (R10 & `MSB_MASK) : R10;
      default: src_out  = 64'bx; 
    endcase // case (src_addr)

    case (dst_addr)
      4'b0000: dst_out  = zeroout ? (R0 & `MSB_MASK) : R0;
      4'b0001: dst_out  = zeroout ? (R1 & `MSB_MASK) : R1;
      4'b0010: dst_out  = zeroout ? (R2 & `MSB_MASK) : R2;
      4'b0011: dst_out  = zeroout ? (R3 & `MSB_MASK) : R3;
      4'b0100: dst_out  = zeroout ? (R4 & `MSB_MASK) : R4;
      4'b0101: dst_out  = zeroout ? (R5 & `MSB_MASK) : R5;
      4'b0110: dst_out  = zeroout ? (R6 & `MSB_MASK) : R6;
      4'b0111: dst_out  = zeroout ? (R7 & `MSB_MASK) : R7;
      4'b1000: dst_out  = zeroout ? (R8 & `MSB_MASK) : R8;
      4'b1001: dst_out  = zeroout ? (R9 & `MSB_MASK) : R9;
      4'b1010: dst_out  = zeroout ? (R10 & `MSB_MASK) : R10;
      default: dst_out = 64'bx; 
    endcase // case (dst_addr)
  end 

  always @ (posedge clk) begin
    if (rst == 1) begin
      R0   = 0;
      R1   = 0;
      R2   = 0;
      R3   = 0;
      R4   = 0;
      R5   = 0;
      R6   = 0;
      R7   = 0;
      R8   = 0;
      R9   = 0;
      R10  = 0;
    end // if (rst == 1)
    else begin
      if (en == 1 && rw == 1) begin
	case (dst_addr)
	  4'b0000: R0  = zeroout ? (dst_in & `MSB_MASK) : dst_in;
	  4'b0001: R1  = zeroout ? (dst_in & `MSB_MASK) : dst_in; 
	  4'b0010: R2  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b0011: R3  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b0100: R4  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b0101: R5  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b0110: R6  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b0111: R7  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b1000: R8  = zeroout ? (dst_in & `MSB_MASK) : dst_in;
	  4'b1001: R9  = zeroout ? (dst_in & `MSB_MASK) : dst_in;  
	  4'b1010: R10 = zeroout ? (dst_in & `MSB_MASK) : dst_in;			 
	endcase	// case (data_addr)
	debug_r1 = R1;	 
	debug_r4 = R4;	 
      end // if (en == 1 && rw == 1)
    end // else: !if(rst == 1)  
  end // always @ (posedge clk)
  
endmodule // reg_bank


  
