module pc (
	   clk,
	   nrst,
	   en,
	   pc_inc,
	   pc_valid,
	   pc_load,
	   data,
	   off,
	   comp_z_alu_out);

  input clk;
  input wire nrst;
  input wire en;
  input wire pc_inc;
  input wire pc_valid;
  input wire pc_load;
  input wire [63:0] off;
  input wire 	    comp_z_alu_out;
  
  inout wire [31:0] data;
  
  reg [31:0]   counter;

  assign data = pc_valid ? counter : 32'bz;

  always @(posedge clk) begin
    // first check for a reset
    if (nrst == 0) begin
      counter <= 0;
    end
    else begin
      // check for a CALL
      if (pc_load == 1) begin
	counter <= data;
      end
      else begin
	// check if we should increment
	if (en == 1) begin
	  // check for a jump
	  if (pc_inc == 0) begin
	    // check the ALU comparator output
	    // x : JA (no comparison done)
	    // 0 : do +1 increment (ignore jump)
	    // 1 : do offset jump
	    case (comp_z_alu_out)
	      1'bx, 1'b1: counter <= counter + off[0 +: 32];
	      1'b0: counter <= counter + 1;
	    endcase // case (comp_z_alu_out)
	  end
	  else begin
	    // ++ increment
	    counter <= counter + 1;
	  end // else: !if(pc_inc == 0)
	end // if (en == 1)
      end // else: !if(pc_load == 1)
    end // else: !if(nrst == 0)
  end // always @ (posedge clk)

endmodule // pc

  
