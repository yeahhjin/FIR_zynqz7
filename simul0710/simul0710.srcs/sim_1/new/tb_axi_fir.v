`timescale 1ns / 1ps

module tb_axi_fir;

  // ================================
  // Clock & Reset
  // ================================
  reg ap_clk = 0;
  reg ap_rst_n = 0;
  wire ap_rst_n_inv;
  assign ap_rst_n_inv = ~ap_rst_n;  //added by yj//
  always #5 ap_clk = ~ap_clk; // 100MHz clock

  // ================================
  // AXI4-Lite Interface
  // ================================
  reg [31:0] s_axi_CTRL_AWADDR;
  reg        s_axi_CTRL_AWVALID;
  wire       s_axi_CTRL_AWREADY;

  reg [31:0] s_axi_CTRL_WDATA;
  reg [3:0]  s_axi_CTRL_WSTRB;
  reg        s_axi_CTRL_WVALID;
  wire       s_axi_CTRL_WREADY;

  wire [1:0] s_axi_CTRL_BRESP;
  wire       s_axi_CTRL_BVALID;
  reg        s_axi_CTRL_BREADY;

  reg [31:0] s_axi_CTRL_ARADDR;
  reg        s_axi_CTRL_ARVALID;
  wire       s_axi_CTRL_ARREADY;

  wire [31:0] s_axi_CTRL_RDATA;
  wire [1:0]  s_axi_CTRL_RRESP;
  wire        s_axi_CTRL_RVALID;
  reg         s_axi_CTRL_RREADY;

  // ================================
  // UUT Instance
  // ================================
  fir DUT (
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .s_axi_CTRL_AWADDR(s_axi_CTRL_AWADDR),
    .s_axi_CTRL_AWVALID(s_axi_CTRL_AWVALID),
    .s_axi_CTRL_AWREADY(s_axi_CTRL_AWREADY),
    .s_axi_CTRL_WDATA(s_axi_CTRL_WDATA),
    .s_axi_CTRL_WSTRB(s_axi_CTRL_WSTRB),
    .s_axi_CTRL_WVALID(s_axi_CTRL_WVALID),
    .s_axi_CTRL_WREADY(s_axi_CTRL_WREADY),
    .s_axi_CTRL_BRESP(s_axi_CTRL_BRESP),
    .s_axi_CTRL_BVALID(s_axi_CTRL_BVALID),
    .s_axi_CTRL_BREADY(s_axi_CTRL_BREADY),
    .s_axi_CTRL_ARADDR(s_axi_CTRL_ARADDR),
    .s_axi_CTRL_ARVALID(s_axi_CTRL_ARVALID),
    .s_axi_CTRL_ARREADY(s_axi_CTRL_ARREADY),
    .s_axi_CTRL_RDATA(s_axi_CTRL_RDATA),
    .s_axi_CTRL_RRESP(s_axi_CTRL_RRESP),
    .s_axi_CTRL_RVALID(s_axi_CTRL_RVALID),
    .s_axi_CTRL_RREADY(s_axi_CTRL_RREADY)
  );

  // ================================
  // Task: Write
  // ================================
  task axi_write;
    input [31:0] addr;
    input [31:0] data;
    begin
      @(posedge ap_clk);
      s_axi_CTRL_AWADDR  <= addr;
      s_axi_CTRL_AWVALID <= 1;
      s_axi_CTRL_WDATA   <= data;
      s_axi_CTRL_WVALID  <= 1;
      s_axi_CTRL_WSTRB   <= 4'b1111;

      // Address 핸드쉐이크 완료 대기 후 AWVALID 내려주기
      wait (s_axi_CTRL_AWREADY == 1);
      @(posedge ap_clk);
      s_axi_CTRL_AWVALID <= 0;

      // Data 핸드쉐이크 완료 대기 후 WVALID 내려주기
      wait (s_axi_CTRL_WREADY == 1);
      @(posedge ap_clk);
      s_axi_CTRL_WVALID <= 0;

      //wait (s_axi_CTRL_BVALID); deleted by yj//
      @(posedge ap_clk);
    end
  endtask

  // ================================
  // Task: Read
  // ================================
  reg [31:0] rdata;
  task axi_read;
    input [31:0] addr;
    begin
      @(posedge ap_clk);
      s_axi_CTRL_ARADDR  <= addr;
      s_axi_CTRL_ARVALID <= 1;

      // Address handshake
      wait (s_axi_CTRL_ARREADY);
      @(posedge ap_clk);
      s_axi_CTRL_ARVALID <= 0;

      wait (s_axi_CTRL_RVALID);
      rdata = s_axi_CTRL_RDATA;
      @(posedge ap_clk);
    end
  endtask

  // ================================
  // Stimulus
  // ================================


integer i,j;
initial begin
  // 초기화
  s_axi_CTRL_AWADDR = 0;
  s_axi_CTRL_AWVALID = 0;
  s_axi_CTRL_WDATA = 0;
  s_axi_CTRL_WSTRB = 4'b1111;
  s_axi_CTRL_WVALID = 0;
  s_axi_CTRL_BREADY = 1;
  s_axi_CTRL_ARADDR = 0;
  s_axi_CTRL_ARVALID = 0;
  s_axi_CTRL_RREADY = 1;

  #200; ap_rst_n = 1;





// 입력값 x 쓰기 (0x10) + fir 계산 //added by yj//
  for (i = 0; i < 32; i = i + 1) begin
      axi_write(32'h10, 32'd2);  // x 값 넣기
      axi_write(32'h00, 32'h01);  // FIR 계산 시작 (ap_start)
      // 지연을 주어 데이터가 정상적으로 전송되도록 함



      j = 0;
    
      while (j < 20 && rdata != 32'd1) begin
        axi_read(32'h1C);  // y_ap_vld check
        j = j + 1;
      end


      // read y
      axi_read(32'h18);
      $display("t=%0d x=%0d -> y=%0d", i, i, rdata);
    end

  #100; $finish;
  end
endmodule
