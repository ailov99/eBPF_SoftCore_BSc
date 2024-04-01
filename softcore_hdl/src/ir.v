module ir(
	  clk,
	  nrst,
	  ir_valid,
	  ir_load,
	  ir_bus);

  input clk;
  input nrst;
  input wire ir_valid;
  input wire ir_load;

  inout wire [63:0] ir_bus;
  reg [63:0]   ir_reg;
  
  assign ir_bus  = ir_valid ? ir_reg : 64'bz;

  always @(*) begin
    ir_reg <= ir_bus;
  end
  
  
  /*
  always @(posedge clk) begin
    if (nrst == 0) begin
      ir_reg <= 0;
    end
    else begin
      if (ir_load == 1) begin
	ir_reg <= ir_bus;
      end
    end
  end
   */

endmodule // ir

