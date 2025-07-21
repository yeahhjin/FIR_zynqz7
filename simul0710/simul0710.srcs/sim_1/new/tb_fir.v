`timescale 1ns / 1ps

module tb_fir;

  // Clock and Reset
  reg ap_clk = 0;
  reg ap_rst_n = 0;
  always #5 ap_clk = ~ap_clk;  // 100MHz

  // AXI-Lite �������̽� ��ȣ
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

  // DUT �ν��Ͻ�
  fir dut (
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

  // AXI Lite helper task�� ����
  task axi_write(input [31:0] addr, input [31:0] data);
    begin
      @(posedge ap_clk);
      s_axi_CTRL_AWADDR  <= addr;
      s_axi_CTRL_AWVALID <= 1;
      s_axi_CTRL_WDATA   <= data;
      s_axi_CTRL_WSTRB   <= 4'b1111;
      s_axi_CTRL_WVALID  <= 1;
      wait (s_axi_CTRL_AWREADY && s_axi_CTRL_WREADY);
      @(posedge ap_clk);
      s_axi_CTRL_AWVALID <= 0;
      s_axi_CTRL_WVALID  <= 0;
      s_axi_CTRL_BREADY  <= 1;
      wait (s_axi_CTRL_BVALID);
      @(posedge ap_clk);
      s_axi_CTRL_BREADY  <= 0;
    end
  endtask

  task axi_read(input [31:0] addr, output [31:0] data);
    begin
      @(posedge ap_clk);
      s_axi_CTRL_ARADDR  <= addr;
      s_axi_CTRL_ARVALID <= 1;
      wait (s_axi_CTRL_ARREADY);
      @(posedge ap_clk);
      s_axi_CTRL_ARVALID <= 0;
      s_axi_CTRL_RREADY  <= 1;
      wait (s_axi_CTRL_RVALID);
      data = s_axi_CTRL_RDATA;
      @(posedge ap_clk);
      s_axi_CTRL_RREADY  <= 0;
    end
  endtask

  // �׽�Ʈ �ó�����
  integer i;
  reg [31:0] y;
  initial begin
    ap_rst_n = 0;
    s_axi_CTRL_AWVALID = 0;
    s_axi_CTRL_WVALID  = 0;
    s_axi_CTRL_BREADY  = 0;
    s_axi_CTRL_ARVALID = 0;
    s_axi_CTRL_RREADY  = 0;
    #100;
    ap_rst_n = 1;

    // FIR ��� 0~10 ���� (AXI �ּ� 0x10���� ����)

    for (i = 0; i < 11; i = i + 1) begin
      axi_write(32'h10 + i*4, i);  // ��: coef[i] = i
    end

    // ��� �ּ� 0 ����
    axi_write(32'h30, 0);

    // �Է°� 7 �Է�
    axi_write(32'h00, 7);

    // ��� �б�

    axi_read(32'h20, y);
    $display(">> FIR ��°�: %d", y);

    #100;
    $finish;
  end

endmodule
