`timescale 1ns / 1ns

module tb_mealy;
logic rst = 0;
logic clk = 1;
logic [1:0]a, y;

//parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

initial begin
  $dumpfile("work/wave.ocd");
  $dumpvars(0, tb_mealy);
end

initial begin
  @(posedge clk);
  rst = 1'b1;
  @(posedge clk);
  rst = 1'b0;
  
  a = 2'b11; @(posedge clk);
  a = 2'b00; @(posedge clk);
  a = 2'b11; @(posedge clk);
  a = 2'b10; @(posedge clk);
  a = 2'b01; @(posedge clk);
  a = 2'b11; @(posedge clk);
  a = 2'b01; @(posedge clk);
  a = 2'b10; @(posedge clk);
  a = 2'b11; @(posedge clk);
  a = 2'b00; @(posedge clk);
  a = 2'b01; @(posedge clk);
  a = 2'b10; @(posedge clk);
  a = 2'b00; @(posedge clk);
  a = 2'b00; @(posedge clk);
  a = 2'b10; @(posedge clk);
  @(posedge clk);

  $finish;
end

always #5 clk = ~clk;

mealy dut (
  .rst(rst),
  .clk(clk),
  .a  (a),
  .y  (y)
);

endmodule
