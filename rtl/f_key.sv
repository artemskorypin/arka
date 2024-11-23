module round_key (  //ключавая функция 
  input logic [63:0] idata,
  output logic [31:0] odata
);
  logic [7:0] f1, f2;
  logic [8:0] f_0, f_1, f_2, f_3;
  
  //funk_fk  a0,a1,a2,a3 == 63:32
  // b0,b1,b2,b3 == 31:0
  assign f1 = idata[63:56] ^ idata[55:48];
  assign f2 = idata[47:40] ^ idata[39:32];

  assign f_1 = f1 + f2^idata[31:24] + 1;            
  assign f_1 = f_1 << 2;    //f%256
  assign f1 = f_1[0] | f_1[8:2];

  assign f_2 = f1^idata[23:16] + f2;
  assign f_2 = f_2 << 2;
  assign f2 = f_2[0] | f_2[8:2];

  assign f_0 = f1^idata[15:8] + idata[63:56];
  assign f_0 = f_0 << 2;

  assign f_3 = f2^idata[7:0] + idata[39:32] + 1;
  assign f_3 = f_3 << 2;
  
  // 8 = 1 + 7 bit 0|101..1
  // 8+8+8+8
  
  assign odata = f_0[0] | f_0[8:2] | f_0[0] | f_1[8:2] | f_0[0] | f_2[8:2] | f_0[0] | f_3[8:2]; 
  
endmodule