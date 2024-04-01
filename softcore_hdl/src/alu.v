`include "inc/opcodes.v"

module alu (
	    clk,
	    src_bus,
	    dst_bus,
	    imm,
	    off,
	    x_slc,
	    y_slc,
	    z,
	    comp_z,
	    op);

  input clk;
  input wire x_slc;
  input wire [1:0] y_slc;
  output reg [63:0] z;
  output wire 	    comp_z;
  input wire [7:0] 	op;
  input wire [63:0] 	src_bus;
  input wire [63:0] 	dst_bus;
  input wire [63:0] 	imm;
  input wire [63:0] 	off;

  wire 		clk;
  wire [63:0] 	x;
  wire [63:0] 	y;

  // X and Y muxes
  assign x  = (x_slc == 1'b0) ? src_bus : dst_bus;
  assign y  = (y_slc == 2'b00) ? src_bus
	      : (y_slc == 2'b01) ? off
	      : imm;
  assign comp_z = z[0];

  always @(*) begin
    case (op)
      `BPF_ADD_IMM,`BPF_ADD_SRC,`BPF_ADD32_IMM,`BPF_ADD32_SRC,
      
      `BPF_LDINDW,`BPF_LDINDB,`BPF_LDINDDW,`BPF_LDINDH,
      `BPF_LDXB,`BPF_LDXH,`BPF_LDXW,`BPF_LDXDW,
      `BPF_STB,`BPF_STH,`BPF_STW,`BPF_STDW,`BPF_STXB,`BPF_STXH,
      `BPF_STXW,`BPF_STXDW:  z 					   = x + y;
      `BPF_LDABSW,`BPF_LDABSB,`BPF_LDABSDW,`BPF_LDABSH: z 	   = y;
      `BPF_SUB_IMM,`BPF_SUB_SRC,`BPF_SUB32_IMM,`BPF_SUB32_SRC:  z  = x - y;
      `BPF_MUL_IMM,`BPF_MUL_SRC,`BPF_MUL32_IMM,`BPF_MUL32_SRC:  z  = x * y;
      `BPF_DIV_IMM,`BPF_DIV_SRC,`BPF_DIV32_IMM,`BPF_DIV32_SRC:  z  = x / y;
      `BPF_OR_IMM,`BPF_OR_SRC,`BPF_OR32_IMM,`BPF_OR32_SRC:      z  = x | y;
      `BPF_AND_IMM,`BPF_AND_SRC,`BPF_AND32_IMM,`BPF_AND32_SRC,
	`BPF_JSET_IMM,`BPF_JSET_SRC:  z 			      = x & y;
      `BPF_LSH_IMM,`BPF_LSH_SRC,`BPF_LSH32_IMM,`BPF_LSH32_SRC:  z     = x << y;
      `BPF_RSH_IMM,`BPF_RSH_SRC,`BPF_RSH32_IMM,`BPF_RSH32_SRC:  z     = x >> y;
      `BPF_NEG,`BPF_NEG32:                                      z     = ~x;
      `BPF_MOD_IMM,`BPF_MOD_SRC,`BPF_MOD32_IMM,`BPF_MOD32_SRC:  z     = x % y;
      `BPF_XOR_IMM,`BPF_XOR_SRC,`BPF_XOR32_IMM,`BPF_XOR32_SRC:  z     = x ^ y;
      `BPF_MOV_IMM,`BPF_MOV_SRC,`BPF_MOV32_IMM,`BPF_MOV32_SRC:  z     = x;
      `BPF_ARSH_IMM,`BPF_ARSH_SRC,`BPF_ARSH32_IMM,`BPF_ARSH32_SRC: z  = x >>> y;
      `BPF_JEQ_IMM,`BPF_JEQ_SRC,`BPF_JNE_IMM,`BPF_JNE_SRC: z 	      = (x == y) ? 1 : 0;
      `BPF_JGT_IMM,`BPF_JGT_SRC: z 				      = (x > y) ? 1 : 0;
      `BPF_JGE_IMM,`BPF_JGE_SRC: z 				      = (x >= y) ? 1 : 0;
      `BPF_JSGT_IMM,`BPF_JSGT_SRC: z 				      = ($signed(x) > $signed(y)) ? 1 : 0;
      `BPF_JSGE_IMM,`BPF_JSGE_SRC: z 				      = ($signed(x) >= $signed(y)) ? 1 : 0;
      default: z 						      = 64'bx;
    endcase // case (op)
  end

endmodule // alu

