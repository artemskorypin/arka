module key_gen (  //генерация ключей
  input logic [63:0] idata,
  output logic [255:0] odata
);
  logic [31:0] block_xor;
  logic [63:0] block;
  logic [31:0] block_end;
  
  // 255-224 223-192 191-160 159-128 127-96 95-64 63-32 31-0
  always @(*) begin
    for(int i = 0; i < 8; i++) begin
	    if (i == 0)
        f_key f_key_inst (
        .idata (idata    ),//64
        .odata (block_end)//32
        );
	      odata[255:224] = block_end;
        block_xor = block_end ^ idata[63:32];
        block = idata[31:0] | block_xor;

      else if (i == 7)
        f_key f_key_inst (
        .idata (block    ),//64
        .odata (block_end)//32
        );
        odata[31:0] = block_end;

      else
        f_key f_key_inst (
        .idata (block    ),//64
        .odata (block_end)//32
        );
        odata[255 - 32*i : 224 - 32*i] = block_end;
        block_xor = block_end ^ block[63:32];
        block = block[31:0] | block_xor;

      end
  end
    
endmodule
