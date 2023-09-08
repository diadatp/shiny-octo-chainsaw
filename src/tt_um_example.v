module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  reg [7:0] stage;

  always @(posedge clk) begin
    if (!rst_n) begin
      stage[0] <= 0;
    end else begin
      stage[0] <= &ui_in;
    end
  end

  generate
    genvar i;
    for (i = 0; i < 7; i = i + 1) begin
      always @(posedge clk) begin
        if (!rst_n) begin
          stage[i+1] <= 0;
        end else begin
          stage[i+1] <= stage[i];
        end
      end
    end
  endgenerate

  assign uo_out  = {8{stage[7]}};
  assign uio_out = uio_in;
  assign uio_oe  = {8{ena}};

endmodule
