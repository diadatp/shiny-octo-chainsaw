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

  reg [99:0] stage;

  always @(posedge clk) begin
    if (!rst_n) begin
      stage[0] <= 0;
    end else begin
      stage[0] <= &ui_in;
    end
  end

  reg [3:0] counter;

  always @(posedge clk) begin
    if (!rst_n) begin
      counter <= 14;
    end else begin
      if (0 == counter) begin
        counter <= 14;
      end else begin
        counter <= counter - 1;
      end
    end
  end

  generate
    genvar i;
    for (i = 0; i < 99; i = i + 1) begin
      always @(posedge clk) begin
        if (!rst_n) begin
          stage[i+1] <= 0;
        end else begin
          if (0 == counter) begin
            stage[i+1] <= stage[i];
          end
        end
      end
    end
  endgenerate

  assign uo_out  = {8{stage[99]}};
  assign uio_out = uio_in;
  assign uio_oe  = {8{ena}};

endmodule
