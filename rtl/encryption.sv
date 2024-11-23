module encryp (// раунд в шифровании? возможно не нужен
  input logic [63:0] idata,
  input logic [255:0] key,//k0,k1,...kc,kd,ke,kf
  output logic [63:0] odata
);
  logic [31:0] block_xor_32;
  logic [63:0] block_xor_64;
  logic [63:0] block;
  logic [63:0] block_end;
  
  assign block_xor_64 = idata ^ key[127:64];
  assign block_xor_32 = block_xor_64[63:32] ^ block_xor_64[31:0];
  assign block = block_xor_64[63:32] | block_xor_32;

  // 255-224 223-192 191-160 159-128 127-96 95-64 63-32 31-0
  // k0-k1    k2-k3  k4-k5    k6,k7   k8,k9 ka-kb kc,kd ke,kf       
  always @(*) begin
    for(int i = 0; i < 8; i++) begin
	    round f_key_inst (
      .idata (block    ),//64
      .idata (key[255 - 16*i : 240 - 16*i]), //16
      .odata (block_end)//64
      );
      block = block_end;
      end
  end

  assign block_xor_32 = block_end[63:32] ^ block_end[31:0];
  assign block = block_end[31:0] | block_xor_32;
  assign odata = block ^ key[63:0];

endmodule