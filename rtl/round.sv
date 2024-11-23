module round (// раунд в шифровании
  input logic [63:0] idata, //left_part, right_part,
  input logic [15:0] key,
  output logic [63:0] odata
);
  logic [31:0] block_xor; 
  logic [7:0] f1, f2;
  logic [8:0] f_0, f_1, f_2, f_3;

  //assign right_part = idata[31:0];
  //assign left_part = idata[63:32];
  
  //funk_f  a0,a1,a2,a3 == 31:0
  assign f1 = idata[31:24] ^ idata[23:16] ^ key[15:8];
  assign f2 = idata[15:8] ^ idata[7:0] ^ key[7:0];

  assign f_1 = f1 + f2 + 1;            
  assign f_1 = f_1 << 2;    //f%256
  //assign f_1 = f_1 >> 1;

  assign f_2 = (f_1[0] | f_1[8:2]) + f2;
  //assign f_2 = f_1[8:1] + f2;
  assign f_2 = f_2 << 2;
  //assign f_2 = f_2 >> 1;
  assign f_0 = (f_1[0] | f_1[8:2]) + right_part[31:24];

  //assign f_0 = f_1[8:1] + right_part[31:24];
  assign f_0 = f_0 << 2;
 // assign f_0 = f_0 >> 1;
  assign f_3 = (f_2[0] | f_2[8:2]) + right_part[7:0] + 1;

 // assign f_3 = f_2[8:1] + right_part[7:0] + 1;
  assign f_3 = f_3 << 2;
  //assign f_3 = f_3 >> 1;
  
  // 8 = 1 + 7 bit 0|101..1
  // 8+8+8+8
  assign block_xor = f_0[0] | f_0[8:2] | f_0[0] | f_1[8:2] | f_0[0] | f_2[8:2] | f_0[0] | f_3[8:2]; 
  assign block_xor = block_xor ^ idata[63:32];
  assign odata = (idata[31:0] << 32) | block_xor;

endmodule