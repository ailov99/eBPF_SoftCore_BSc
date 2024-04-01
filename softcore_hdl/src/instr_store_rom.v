module instr_store_rom (
			clk,
			rst,
			addr,
			instr);

  input clk;
  input rst;
  input [31:0] addr;
  output reg [63:0] instr;

  reg [63:0] 	data;
 
  // Stub bytecode: 
  // lddw r1, #0x4
  // lddw r4, #0x6
  // add 2,r4
  // exit
  
  always @ (addr) begin
    case (addr)
      0 : data 	= 64'h0000000200000118;  // #R1 = 1
      1 : data 	= 64'h0000000200020115;  // ldabsb [4], R1
      2 : data 	= 64'h0000000200000418; 
      3 : data 	= 64'h0000000000000095;
    endcase // case (addr)
  end

  always @(*) begin
    instr <= data;
  end
  
  
  /*
  always @ (posedge clk) begin
    if (rst) begin
      data <= 64'hxxxxxxxxxxxxxxxx;
    end
    else begin
      instr <= data;
    end		
  end*/
 
  
endmodule // instr_store_rom

  
