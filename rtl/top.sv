module gost_pipelined (
  input logic rst,
  input logic clk,

  input logic [63:0] key_start,

  input  logic [63:0] s_axis_tdata,
  input  logic        s_axis_tvalid,
  output logic        s_axis_tready,

  output logic [63:0] m_axis_tdata,
  output logic        m_axis_tvalid,
  input  logic        m_axis_tready
);

  logic [63:0] block     [8];
  logic        valid     [8];
  logic [63:0] enc_block [8];
  logic [255:0] key;
  
  key_gen key_gen_inst (
        .idata (key_start),
        .odata (key)
  );

  logic [31:0] block_xor_32;
  logic [63:0] block_xor_64;
  logic [63:0] block_end;
  logic [63:0] odata;
  

  generate
    for (genvar i = 0; i < 8; i++) begin
      round f_key_inst (
      .idata (block[i]    ),//64
      .idata (key[255 - 16*i : 240 - 16*i]), //16
      .odata (enc_block[i])//64
      );

      always @(posedge clk) begin
        if (rst) begin
          valid[i] <= 1'b0;
          block[i] <= '0;
        end else if (m_axis_tready) begin
          if (i == 0) begin
            valid[i] <= s_axis_tvalid;
            block_xor_64 = s_axis_tdata ^ key[127:64];
            block_xor_32 = block_xor_64[63:32] ^ block_xor_64[31:0];
            block[i] <= block_xor_64[63:32] | block_xor_32;

          end else begin
            valid[i] <= valid[i-1];
            block[i] <= enc_block[i-1];
          end
        end
      end
    end
  endgenerate
  
  assign block_xor_32 = enc_block[7][63:32] ^ enc_block[7][31:0];
  assign block_end = enc_block[7][31:0] | block_xor_32;
  assign odata = block_end ^ key[63:0]; 

  always @(posedge clk) begin
    if (rst) begin
      m_axis_tdata  <= '0;
      m_axis_tvalid <= 1'b0;
    end else if (m_axis_tready) begin
      m_axis_tdata  <= odata;
      m_axis_tvalid <= valid[7];
    end
  end

  assign s_axis_tready = m_axis_tready;

endmodule
