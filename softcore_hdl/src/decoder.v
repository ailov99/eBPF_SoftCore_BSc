`define IMM 32
`define OFF 16
`define SRC 4
`define DST 4
`define OP  8

module decoder (
		instr,
		imm,
		off,
		src,
		dst,
		op);

  input wire [63:0] instr;

  output reg [63:0] imm;
  output reg [63:0] off;
  output reg [`SRC-1:0] src;
  output reg [`DST-1:0] dst;
  output reg [`OP-1:0]  op;

  always @ (instr) begin
    imm <= $signed(instr[32 +: `IMM]);
    off <= $signed(instr[16 +: `OFF]);
    src <= instr[12 +: `SRC];
    dst <= instr[8 +: `DST];
    op  <= instr[0 +: `OP];
  end
  

endmodule //decoder
