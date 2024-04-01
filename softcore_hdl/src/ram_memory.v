// Use directives to specify the memory layout
// this includes depth and addressing
`define DIM_BASE 2
`define DIM_EXP 4

module ram_memory (
		   clk,
		   rst,
		   load,
		   madd,
		   //roff,
		   //coff,
		   mem_mode,
		   src_bus,
		   imm,
		   data_in_slc,
		   data_out);

  input clk;
  input wire rst;
  input wire load;
  //input [`DIM_EXP-1:0]  roff;
  //input [`DIM_EXP-1:0]  coff;
  input wire [1:0] mem_mode;
  input wire [63:0] 	madd; // mem address
  input wire [63:0] 	src_bus;
  input wire [63:0] 	imm;
  input wire		data_in_slc;
  output reg [63:0] 	data_out;

  wire [63:0] 	       data_in;

  // the memory array definition
  // 64 bits wide
  // base**exp - 1 address "depth"
  reg [`DIM_BASE**`DIM_EXP-1:0] memory;
  
  assign data_in = (data_in_slc == 0) ? src_bus : imm;

  always @ (madd, mem_mode) begin
    case (mem_mode)
      2'b00: data_out 	<= memory[madd +: 8];
      2'b01: data_out 	<= memory[madd +: 16];
      2'b10: data_out 	<= memory[madd +: 32];
      2'b11: data_out 	<= memory[madd +: 64];
      default: data_out <= 64'bx;
    endcase // case (mem_mode)
  end
  
  always @ (posedge clk) begin
    if (rst) begin
      memory <= {1008'h0,16'hefef};
    end
    else begin
      if (load) begin
	case (mem_mode)
	  2'b00: memory[madd +: 8] <= data_in[0 +: 8];
	  2'b01: memory[madd +: 16] <= data_in[0 +: 16];
	  2'b10: memory[madd +: 32] <= data_in[0 +: 32];
	  2'b11: memory[madd +: 64] <= data_in;
	endcase // case (mem_mode)
      end			
    end // else: !if(rst)
  end // always @ (posedge clk)
    
endmodule // ram_memory

		   
