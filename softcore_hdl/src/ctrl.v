`include "inc/opcodes.v"

module ctrl(
	    clk,
	    rst,
	    op,
	    branch_on,
	    x_alu_in,
	    y_alu_in,
	    mem_load,
	    mem_len,
	    mem_data_in_slc,
	    pc_en,
	    pc_inc,
	    pc_valid,
	    pkt_buf_bytecount,
	    reg_bank_in,
	    reg_bank_rw,
	    reg_bank_zeroout,
	    reg_bank_en,
	    ir_load,
	    ir_valid,
	    call,
	    debug_state,
	    debug_next_state);

  input clk;
  input wire rst;
  input wire [7:0] op;
  input wire 	   branch_on;
  output reg [7:0] debug_state;
  output reg [7:0] debug_next_state;
  output reg       x_alu_in;		
  output reg [1:0] y_alu_in;
  output reg 	   mem_load;
  output reg [1:0] mem_len;
  output reg 	   mem_data_in_slc;
  output reg 	   pc_inc;
  output reg [1:0] pkt_buf_bytecount;
  output reg 	   pc_en;
  output reg 	   pc_valid;
  output reg 	   call;
  output reg [1:0] reg_bank_in;
  output reg 	   reg_bank_rw;
  output reg 	   reg_bank_zeroout;
  output reg 	   ir_load;
  output reg 	   ir_valid;
  output reg 	   reg_bank_en;
  

  // States as params
  parameter ST_ENC_LEN 	= 8;
  
  parameter ST_IDLE      = 8'h00;
  parameter ST_FETCH     = 8'h01;
  parameter ST_INC       = 8'h02;
  parameter ST_ALU_SRC   = 8'h03;
  parameter ST_ALU_IMM   = 8'h04;
  parameter ST_ALU32_SRC = 8'h05;
  parameter ST_ALU32_IMM = 8'h06;
  parameter ST_LDDW      = 8'h07;
  parameter ST_PKT_LDB   = 8'h08;
  parameter ST_PKT_LDH 	 = 8'h09;
  parameter ST_PKT_LDW 	 = 8'h0a;
  parameter ST_PKT_LDDW  = 8'h0b;
  parameter ST_LDXB      = 8'h0c;
  parameter ST_LDXH      = 8'h0d;
  parameter ST_LDXW      = 8'h0e;
  parameter ST_LDXDW     = 8'h0f;
  parameter ST_STB       = 8'h10;
  parameter ST_STH       = 8'h11;
  parameter ST_STW       = 8'h12;
  parameter ST_STDW      = 8'h13;
  parameter ST_STXB      = 8'h14;
  parameter ST_STXH      = 8'h15;
  parameter ST_STXW      = 8'h16;
  parameter ST_STXDW     = 8'h17;
  parameter ST_JA        = 8'h18;
  parameter ST_BRANCH_IMM= 8'h19;
  parameter ST_BRANCH_SRC= 8'h20;
  parameter ST_CALL      = 8'h21;
  parameter ST_TRAP      = 8'hff;
  
  
  

  
  
  
  
  
  // Internal state information
  reg [ST_ENC_LEN-1:0] state;

  always @(state)
    begin
      debug_state = state;
      case (state)
	ST_IDLE: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
      	  call 		    <= 1'b0;
	end // case: ST_IDLE
	
	ST_FETCH: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b1;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b1;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_FETCH
	
	ST_INC: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b1;
	  pc_en 	    <= 1'b1;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_INC
	
	ST_ALU_IMM: begin
	  // latch dst out of reg_bank
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b10;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_ALU_IMM1

	ST_ALU32_IMM: begin
	  // latch dst out of reg_bank
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b1;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_ALU32_IMM1

	
	ST_ALU_SRC: begin
	  // latch dst and src out of reg_bank
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_ALU_SRC1

	ST_ALU32_SRC: begin
	  // latch dst and src out of reg_bank
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b1;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_ALU32_SRC1

	ST_LDDW: begin
	  // save IMM into reg_bank
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b10;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_LDDW

	ST_PKT_LDB: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b10;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b01;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_PKT_LDB

	ST_PKT_LDH: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b10;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b01;
	  reg_bank_in 	    <= 2'b01;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_PKT_LDB

	ST_PKT_LDW: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b10;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b10;
	  reg_bank_in 	    <= 2'b01;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_PKT_LDB

	ST_PKT_LDDW: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b10;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b11;
	  reg_bank_in 	    <= 2'b01;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_PKT_LDB

	ST_LDXB: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b01;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b11;
	  reg_bank_rw 	    <= 1'b1;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b1;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_LDXB

	ST_STB: begin
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b01;
	  mem_load 	    <= 1'b1;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b1;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b0;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_STB
	
	ST_JA: begin
	  x_alu_in 	    <= 1'b0;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b1;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_JA

	ST_BRANCH_IMM: begin
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b10;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b1;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_BRANCH_IMM
	
	ST_BRANCH_SRC: begin
	  x_alu_in 	    <= 1'b1;
	  y_alu_in 	    <= 2'b00;
	  mem_load 	    <= 1'b0;
	  mem_len 	    <= 2'b00;
	  mem_data_in_slc   <= 1'b0;
	  pc_inc 	    <= 1'b0;
	  pc_en 	    <= 1'b1;
	  pc_valid 	    <= 1'b0;
	  pkt_buf_bytecount <= 2'b00;
	  reg_bank_in 	    <= 2'b00;
	  reg_bank_rw 	    <= 1'b0;
	  reg_bank_zeroout  <= 1'b0;
	  reg_bank_en 	    <= 1'b0;
	  ir_load 	    <= 1'b0;
	  ir_valid 	    <= 1'b0;
	  call 		    <= 1'b0;
	end // case: ST_BRANCH_SRC

	
	ST_TRAP: begin
	  x_alu_in 	    <= 1'bx;
	  y_alu_in 	    <= 2'bx;
	  mem_load 	    <= 1'bx;
	  mem_len 	    <= 2'bx;
	  mem_data_in_slc   <= 1'bx;
	  pc_inc 	    <= 1'bx;
	  pc_en 	    <= 1'bx;
	  pc_valid 	    <= 1'bx;
	  pkt_buf_bytecount <= 2'bx;
	  reg_bank_in 	    <= 2'bx;
	  reg_bank_rw 	    <= 1'bx;
	  reg_bank_zeroout  <= 1'bx;
	  reg_bank_en 	    <= 1'bx;
	  ir_load 	    <= 1'bx;
	  ir_valid 	    <= 1'bx;
	  call 		    <= 1'bx;
	end // case: ST_TRAP
	
	
	
	
      endcase // case (state)
    end // always @ (state)

  
  always @(posedge clk)
    begin
      //ir_valid <= #1 1'b1;
      if (rst == 1)
	state  = ST_IDLE;
      else
	ir_valid <= #1 1'b1;
	case (state)
	  ST_IDLE: state  <= #2 ST_FETCH;
	  ST_FETCH:
	    begin
	      #2
	      case (op)
		`BPF_LDDW: state <= ST_LDDW;
		
		`BPF_ADD_SRC,`BPF_SUB_SRC,`BPF_MUL_SRC,`BPF_DIV_SRC,
		  `BPF_OR_SRC,`BPF_AND_SRC,`BPF_LSH_SRC,`BPF_RSH_SRC,
                  `BPF_NEG,`BPF_MOD_SRC,`BPF_XOR_SRC,`BPF_MOV_SRC,
		  `BPF_ARSH_SRC: state <= ST_ALU_SRC;

		`BPF_ADD32_SRC,`BPF_SUB32_SRC,`BPF_MUL32_SRC,`BPF_DIV32_SRC,
		  `BPF_OR32_SRC,`BPF_AND32_SRC,`BPF_LSH32_SRC,`BPF_RSH32_SRC,
		  `BPF_NEG32,`BPF_MOD32_SRC,`BPF_XOR32_SRC,`BPF_MOV32_SRC,
		  `BPF_ARSH32_SRC: state <= ST_ALU32_SRC;
		
		`BPF_ADD32_IMM,`BPF_SUB32_IMM,`BPF_MUL32_IMM,`BPF_DIV32_IMM,
		  `BPF_OR32_IMM,`BPF_AND32_IMM,`BPF_LSH32_IMM,`BPF_RSH32_IMM,
		  `BPF_MOD32_IMM,`BPF_XOR32_IMM,`BPF_MOV32_IMM,
		  `BPF_ARSH32_IMM: state <= ST_ALU32_IMM;
		
		`BPF_ADD_IMM,`BPF_SUB_IMM,`BPF_MUL_IMM,`BPF_DIV_IMM,
                  `BPF_OR_IMM,`BPF_AND_IMM,`BPF_LSH_IMM,`BPF_LSH_IMM,
                  `BPF_MOD_IMM,`BPF_XOR_IMM,`BPF_MOV_IMM,
		  `BPF_ARSH_IMM: state 		 <= ST_ALU_IMM;

		
		`BPF_LDINDW,`BPF_LDABSW: state 	 <= ST_PKT_LDW;
		`BPF_LDINDH,`BPF_LDABSH: state 	 <= ST_PKT_LDH;
		`BPF_LDINDB,`BPF_LDABSB: state 	 <= ST_PKT_LDB;
		`BPF_LDINDDW,`BPF_LDABSDW: state <= ST_PKT_LDDW;

		`BPF_LDXB: state 		 <= ST_LDXB;
		`BPF_LDXH: state 		 <= ST_LDXH;
		`BPF_LDXW: state 		 <= ST_LDXW;
		`BPF_LDXDW: state 		 <= ST_LDXDW;
		
		`BPF_STB: state 		 <= ST_STB;
		`BPF_STH: state 		 <= ST_STH;
		`BPF_STW: state 		 <= ST_STW;
		`BPF_STDW: state 		 <= ST_STDW;

		`BPF_STXB: state 		 <= ST_STXB;
		`BPF_STXH: state 		 <= ST_STXH;
		`BPF_STXW: state 		 <= ST_STXW;
		`BPF_STXDW: state 		 <= ST_STXDW;

		`BPF_JA: state 			 <= ST_JA;
		
		`BPF_JEQ_IMM,`BPF_JGT_IMM,`BPF_JGE_IMM,`BPF_JSET_IMM,
		  `BPF_JNE_IMM,`BPF_JSGT_IMM,
		  `BPF_JSGE_IMM: state <= ST_BRANCH_IMM;
		
		`BPF_JEQ_SRC,`BPF_JGT_SRC,`BPF_JGE_SRC,`BPF_JSET_SRC,
		  `BPF_JNE_SRC,`BPF_JSGT_SRC,
		  `BPF_JSGE_SRC: state <= ST_BRANCH_SRC;
		
		`BPF_CALL: state       <= ST_CALL;
		`BPF_EXIT: state       <= ST_TRAP;
		
						   
		default: state 	       <= ST_IDLE;
	      endcase // case (op)
	    end
	  ST_INC,ST_JA: state <= #2 ST_FETCH;

	  ST_BRANCH_IMM,ST_BRANCH_SRC: begin
	      if (branch_on == 1) begin
		state <= #2 ST_FETCH;
	      end
	      else begin
		state <= #2 ST_INC;
	      end
	    end
	  
	  
	  ST_LDDW,ST_ALU_SRC,ST_ALU32_SRC,ST_ALU32_IMM,ST_ALU_IMM,
	    ST_PKT_LDW,ST_PKT_LDH,ST_PKT_LDB,ST_PKT_LDDW,ST_LDXB,
	    ST_LDXH,ST_LDXW,ST_LDXDW,ST_STB,ST_STH,ST_STW,ST_STDW,
	    ST_STXB,ST_STXH,ST_STXW,ST_STXDW: state <= #2 ST_INC;

	  ST_TRAP: state <= #2 ST_TRAP;
	  
	  
	  
	endcase // case (state)
    end // always @ (posedge clk)
  
  
endmodule // ctrl

