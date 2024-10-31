`timescale 1ns / 1ps
// (C) Copyright 2020 - 2021 Xilinx, Inc.
// SPDX-License-Identifier: Apache-2.0




module mrmac_10g_mux(
 input  wire           tx_s_aclk,
 input  wire           tx_s_aresetn,
 input  wire           tx_s_axis_tvalid,            
 output wire           tx_s_axis_tready,           
 input  wire [63 : 0]  tx_s_axis_tdata,    
 input  wire [7 : 0]   tx_s_axis_tkeep,     
 input  wire           tx_s_axis_tlast,            
 output wire           tx_m_axis_tvalid,         
 input  wire           tx_m_axis_tready,           
 output wire [63 : 0]  tx_m_axis_tdata, 
 output wire [7 : 0]   tx_m_axis_tkeep,   
 output wire           tx_m_axis_tlast,
 input  wire           rx_s_aclk,
 input  wire           rx_s_aresetn, 
 input  wire           rx_s_axis_tvalid,            
          
 input  wire [63 : 0]  rx_s_axis_tdata,    
 input  wire [7 : 0]   rx_s_axis_tkeep,     
 input  wire           rx_s_axis_tlast, 
 output wire           rx_s_axis_tready, 
 output wire           rx_m_axis_tvalid,         
 input  wire           rx_m_axis_tready,           
 output wire [63 : 0]  rx_m_axis_tdata, 
 output wire [7 : 0]   rx_m_axis_tkeep,   
 output wire           rx_m_axis_tlast, 
 input  wire           sel_10g_mode
    );
    
   wire          tx_mm_axis_tvalid;                        
   wire [31 : 0] tx_mm_axis_tdata;    
   wire [3 : 0]  tx_mm_axis_tkeep;     
   wire          tx_mm_axis_tlast;           
   wire          tx_ss_axis_tready; 
   wire          rx_mm_axis_tvalid;                        
   wire [63 : 0] rx_mm_axis_tdata;    
   wire [7 : 0]  rx_mm_axis_tkeep;     
   wire          rx_mm_axis_tlast;    
axis_dwidth_converter_tx i_axis_dwidth_converter_tx (
  .aclk         (tx_s_aclk),                    // input wire aclk
  .aresetn      (tx_s_aresetn),              // input wire aresetn
  .s_axis_tvalid(tx_s_axis_tvalid),   // input wire s_axis_tvalid
  .s_axis_tready(tx_ss_axis_tready),   // output wire s_axis_tready
  .s_axis_tdata (tx_s_axis_tdata),    // input wire [63 : 0] s_axis_tdata
  .s_axis_tkeep (tx_s_axis_tkeep),    // input wire [7 : 0] s_axis_tkeep
  .s_axis_tlast (tx_s_axis_tlast),    // input wire s_axis_tlast
  .m_axis_tvalid(tx_mm_axis_tvalid),   // output wire m_axis_tvalid
  .m_axis_tready(tx_m_axis_tready),   // input wire m_axis_tready
  .m_axis_tdata (tx_mm_axis_tdata),    // output wire [31 : 0] m_axis_tdata
  .m_axis_tkeep (tx_mm_axis_tkeep),    // output wire [3 : 0] m_axis_tkeep
  .m_axis_tlast (tx_mm_axis_tlast)     // output wire m_axis_tlast
);
    
    assign tx_m_axis_tlast  = (sel_10g_mode==1'b1)? tx_mm_axis_tlast : tx_s_axis_tlast;
    assign tx_m_axis_tkeep  = (sel_10g_mode==1'b1)? {4'h0,tx_mm_axis_tkeep} : tx_s_axis_tkeep;    
    assign tx_m_axis_tdata  = (sel_10g_mode==1'b1)? {32'h00000000,tx_mm_axis_tdata} : tx_s_axis_tdata;
    assign tx_m_axis_tvalid = (sel_10g_mode==1'b1)? tx_mm_axis_tvalid : tx_s_axis_tvalid;
    assign tx_s_axis_tready = (sel_10g_mode==1'b1)? tx_ss_axis_tready :tx_m_axis_tready;
    
	
axis_dwidth_converter_rx i_axis_dwidth_converter_rx (
  .aclk         (rx_s_aclk),                   // input wire aclk
  .aresetn      (rx_s_aresetn),                // input wire aresetn
  
  .s_axis_tvalid(rx_s_axis_tvalid),         // input wire s_axis_tvalid
  .s_axis_tready(rx_s_axis_tready),   		// output wire s_axis_tready
  .s_axis_tdata (rx_s_axis_tdata[31:0]),    // input wire [31 : 0] s_axis_tdata
  .s_axis_tkeep (rx_s_axis_tkeep[3:0]),     // input wire [3 : 0] s_axis_tkeep
  .s_axis_tlast (rx_s_axis_tlast),          // input wire s_axis_tlast
  
  .m_axis_tvalid(rx_mm_axis_tvalid),        // output wire m_axis_tvalid
  .m_axis_tready(rx_m_axis_tready),         // input wire m_axis_tready
  .m_axis_tdata (rx_mm_axis_tdata),         // output wire [63 : 0] m_axis_tdata
  .m_axis_tkeep (rx_mm_axis_tkeep),         // output wire [7 : 0] m_axis_tkeep
  .m_axis_tlast (rx_mm_axis_tlast)          // output wire m_axis_tlast
);	
 assign rx_m_axis_tvalid = (sel_10g_mode==1'b1)? rx_mm_axis_tvalid : rx_s_axis_tvalid;                    
 assign rx_m_axis_tdata  = (sel_10g_mode==1'b1)? rx_mm_axis_tdata  : rx_s_axis_tdata;    
 assign rx_m_axis_tkeep  = (sel_10g_mode==1'b1)? rx_mm_axis_tkeep   : rx_s_axis_tkeep;      
 assign rx_m_axis_tlast  = (sel_10g_mode==1'b1)? rx_mm_axis_tlast   : rx_s_axis_tlast;      
    
endmodule
