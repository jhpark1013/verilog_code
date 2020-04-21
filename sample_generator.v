// Code your design here
module sample_generator#(parameter  C_M_AXIS_TDATA_WIDTH = 8,
                        parameter  C_M_START_COUNT =8)

  (input wire En,
  input wire M_AXIS_tvalid,
  input wire M_AXIS_tlast,
  input wire M_AXIS_tready,
   input wire [7:0] M_AXIS_tdata,
   input [7:0] FrameSize,
  input wire Clk,
  input wire ResetN);

  reg counterR;
  assign M_AXIS_tdata = counterR;
  always @(posedge Clk)
    if(!ResetN)
      counterR <= 0;
  	else begin
      if(M_AXIS_tvalid && M_AXIS_tready)
        if(M_AXIS_tlast)
          counterR <= 0;
      	else
          counterR<=counterR + 1;
    end

  reg sampleGeneratorEnableR;
  reg afterResetCycleCounterR;
  always @(posedge Clk)
    if(!ResetN)begin
      afterResetCycleCounterR <= 0;
      sampleGeneratorEnableR <= 0;
    end
  	else begin
      afterResetCycleCounterR <= afterResetCycleCounterR+1;
      if(afterResetCycleCounterR == C_M_START_COUNT)
        sampleGeneratorEnableR <= 1;
    end

  reg tvalidR;
  assign M_AXIS_tvalid = tvalidR;
  always @(posedge Clk)
    if(!ResetN)
      tvalidR <=0;
  	else begin
      if (!En)
        tvalidR<=0;
      else if(sampleGeneratorEnableR)
        tvalidR<=1;
    end

  reg [7:0] packetCounter;
  reg framesize_test;
  always @(posedge Clk)
    if(!ResetN) begin
      packetCounter <= 8'hff;
      framesize_test <= 0;
    end
  	else begin
      if (M_AXIS_tlast) begin
        packetCounter <= 8'hff;
        framesize_test <= 0;
      end
      else begin
        packetCounter <= packetCounter + 1;
        framesize_test <= framesize_test+1;
      end
    end
      assign M_AXIS_tlast = (framesize_test == 6) ? 1 : 0;


endmodule
