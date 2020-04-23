// Code your testbench here
// or browse Examples
module sample_generator_testbench#(parameter  C_M_AXIS_TDATA_WIDTH = 8,
                                  parameter  C_M_START_COUNT =8);

  parameter half_cycle = 5;
  parameter max_time = 1000;

  reg En ;
  reg [7:0] FrameSize;

  reg M_AXIS_tvalid;
  reg [7:0] M_AXIS_tdata;
  reg M_AXIS_tlast;

  reg M_AXIS_tready;
  reg Clk;
  reg ResetN;

  sample_generator dut(.En(En),
                       .FrameSize(FrameSize),
                       .M_AXIS_tlast(M_AXIS_tlast),
                       .M_AXIS_tdata(M_AXIS_tdata),
                       .M_AXIS_tvalid(M_AXIS_tvalid),
                       .M_AXIS_tready(M_AXIS_tready),
                       .Clk(Clk),
                       .ResetN(ResetN));

  initial begin
    En = 0;
    FrameSize = 8;
    M_AXIS_tready = 0;
    M_AXIS_tdata = 0;
    M_AXIS_tvalid = 0;
    M_AXIS_tlast = 0;
    Clk = 0;
  end

  always
    begin
       #half_cycle Clk = ~Clk;
  end

  initial begin
    ResetN = 0;
    #100 ResetN = 1;
  end

  initial begin
       En = 1;
  end

  initial begin
    M_AXIS_tready = 0;
    #150 M_AXIS_tready = 1;
  end

  initial begin
    M_AXIS_tvalid = 0;
    #200 M_AXIS_tvalid = 1;
  end

  initial // tell the simulator when to end
      #max_time $finish;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule
