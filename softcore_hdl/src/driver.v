`timescale 1ns / 1ps				

`include "alu.v"
`include "ctrl.v"
`include "decoder.v"
`include "instr_store_rom.v"
`include "ir.v"
`include "pc.v"
`include "pkt_buf.v"
`include "ram_memory.v"
`include "reg_bank.v"

module driver();

  // interconnects
  reg clock;
  wire [63:0] x_alu_in;
  wire [63:0] y_alu_in;
  wire [63:0] z_alu_out;
  wire [7:0]  op;
  wire [3:0]  dst;
  wire [3:0]  src;
  wire [63:0] imm;
  wire [63:0] off;
  wire [63:0] curr_instr;
  wire [31:0] instr_address;
  reg 	      instr_rom_rst;
  reg 	      ctrl_rst;
  reg 	      ram_mem_rst;
  wire 	      ctrl_x_alu_in;
  wire [1:0]  ctrl_y_alu_in;
  wire 	      ctrl_mem_load;
  wire [1:0]  ctrl_mem_len;
  wire 	      ctrl_mem_data_in_slc;
  wire 	      ctrl_pc_en;
  wire 	      ctrl_pc_inc;
  wire 	      ctrl_call;
  reg 	      ir_nrst;
  wire 	      ir_valid;
  wire 	      ir_load;
  reg 	      pc_nrst;
  wire 	      pc_en;
  wire 	      pc_inc;
  wire 	      pc_load;
  reg 	      pkt_buf_rst;
  wire 	      pkt_buf_load;
  wire [1:0]  ctrl_pkt_buf_bytecount;
  wire [63:0] pkt_buf_data_out;
  wire [1023:0] pkt_buf_data_in;
  wire 		ram_mem_load;
  wire [63:0] 	ram_data_out;
  reg 		reg_bank_rst;
  wire [3:0] 	ctrl_src_addr;
  wire [3:0] 	ctrl_dst_addr;
  wire [1:0] 	ctrl_reg_bank_in;
  wire 		ctrl_reg_bank_rw;
  wire 		ctrl_reg_bank_zeroout;
  wire [63:0] 	src_reg_out_bus;
  wire [63:0] 	dst_reg_out_bus;
  wire 		reg_bank_en;
  wire 		ctrl_pc_valid;
  wire [7:0] 	debug_state;
  wire [7:0] 	debug_next_state;
  wire [63:0] 	debug_r1;
  wire [63:0] 	debug_r4;
  wire 		comp_z_alu_out;
  
  // simulation
  initial begin
    //$display ("time\t clk curr_instr imm off src dst op");
    //$monitor ("%g\t %b %h %h %h %h %h %h",
    //	      $time, clock, curr_instr, imm, off, src, dst, op);
    //$display ("time\t clk x_in y_in imm_in off_in z_out x_slc y_slc op");
    //$monitor ("%g\t %b %h %h %h %h %h %h %h %h",
    //	      $time, clock, src_reg_out_bus, dst_reg_out_bus, imm, off,
    //	      z_alu_out, ctrl_x_alu_in, ctrl_y_alu_in, op);
    //$display ("time\t clk curr_instr instr_addr ir_valid ir_load pc_en pc_inc pc_valid ctrl_call");
    //$monitor ("%g\t %b %h %h %h %h %h %h %h %h",
    //	      $time, clock, curr_instr, instr_address, ir_valid, ir_load, ctrl_pc_en, ctrl_pc_inc, ctrl_pc_valid, ctrl_call);
    $display ("time clk");
    $monitor ("%g %b %h %h %h %h %h %h %h %h %h %h %h %h %h %h %h",
	      $time, clock, op, ctrl_rst, debug_state, instr_address, ctrl_pc_inc, ctrl_pc_en, ctrl_pc_valid, ir_load, ir_valid, src_reg_out_bus, dst_reg_out_bus, z_alu_out, debug_r1, src, dst);
	      
    clock 	   = 1;
    ctrl_rst 	   = 1;
    ir_nrst 	   = 0;
    pc_nrst 	   = 0;
    pkt_buf_rst    = 1;
    reg_bank_rst   = 1;
    instr_rom_rst  = 1;
    ram_mem_rst    = 1;
   
    #6 ctrl_rst    = 0;
    ir_nrst 	   = 1;
    pc_nrst 	   = 1;
    pkt_buf_rst    = 0;
    reg_bank_rst   = 0;
    instr_rom_rst  = 0;
    ram_mem_rst    = 0;
   
    
    #90 $finish;
  end
  
  // clock ticks
  always begin
    #5 clock  = ~clock;
  end
 
  // module instances
  alu U_alu (clock, 
	     src_reg_out_bus, 
	     dst_reg_out_bus, 
	     imm, 
	     off,
	     ctrl_x_alu_in,
	     ctrl_y_alu_in, 
	     z_alu_out,
	     comp_z_alu_out,
	     op);
  ctrl U_ctrl(clock,
	      ctrl_rst,
	      op,
	      comp_z_alu_out,
	      ctrl_x_alu_in,
	      ctrl_y_alu_in,
	      ctrl_mem_load,
	      ctrl_mem_len, 
	      ctrl_mem_data_in_slc,
	      ctrl_pc_en, 
	      ctrl_pc_inc, 
	      ctrl_pc_valid,
	      ctrl_pkt_buf_bytecount, 
	      ctrl_reg_bank_in, 
	      ctrl_reg_bank_rw, 
	      ctrl_reg_bank_zeroout, 
	      reg_bank_en,
	      ir_load, 
	      ir_valid, 
	      ctrl_call, 
	      debug_state, 
	      debug_next_state); 
  decoder U_decoder(curr_instr,
		    imm, 
		    off, 
		    src, 
		    dst,
		    op);
  instr_store_rom U_instr_store_rom(clock,
				    instr_rom_rst,
				    instr_address, 
				    curr_instr);
  ir U_ir(clock,
	  ir_nrst,
	  ir_valid,
	  ir_load, 
	  curr_instr);
  pc U_pc(clock, 
	  pc_nrst, 
	  ctrl_pc_en, 
	  ctrl_pc_inc,
	  ctrl_pc_valid,
	  ctrl_call,
	  instr_address,
	  off,
	  comp_z_alu_out);
  pkt_buf U_pkt_buf(clock,
		    pkt_buf_rst,
		    pkt_buf_load,
		    z_alu_out,
		    ctrl_pkt_buf_bytecount,
		    pkt_buf_data_in,
		    pkt_buf_data_out);
  ram_memory U_ram_memory(clock, 
			  ram_mem_rst, 
			  ctrl_mem_load,
			  z_alu_out,
			  ctrl_mem_len, 
			  src_reg_out_bus, 
			  imm,
			  ctrl_mem_data_in_slc, 
			  ram_data_out );
  reg_bank U_reg_bank(clock, 
		      reg_bank_en, 
		      reg_bank_rst,
		      src_reg_out_bus,
		      dst_reg_out_bus,
		      src,
		      dst,
		      ctrl_reg_bank_in,
		      z_alu_out, 
		      pkt_buf_data_out,
		      ram_data_out,
		      imm,
		      ctrl_reg_bank_rw,
		      ctrl_reg_bank_zeroout,
		      debug_r1,
		      debug_r4);

endmodule // driver

