
`timescale 1ns/10ps
module LBP ( 
    clk, 
    reset, 
    gray_addr, 
    gray_req, 
    gray_ready, 
    gray_data, 
    lbp_addr, 
    lbp_valid, 
    lbp_data, 
    finish
);

input   [1      -1:0]   clk;            //  Positive Edge
input   [1      -1:0]   reset;          //  Active-High Asynchronous

input   [1      -1:0]   gray_ready;     //  Active-High   
input   [8      -1:0]   gray_data;      //

output  [14     -1:0]   gray_addr;      // 
output  [1      -1:0]   gray_req;       //  Active-High
output  [14     -1:0]   lbp_addr;       //
output  [1      -1:0]   lbp_valid;      //  Active-High
output  [8      -1:0]   lbp_data;       //
output  [1      -1:0]   finish;         //  Active-High
//====================================================================

reg     [8      -1:0]   gray_data_reg;

reg     [14     -1:0]   gray_addr;
reg     [1      -1:0]   gray_req;
reg     [14     -1:0]   lbp_addr;
reg     [1      -1:0]   lbp_valid;
reg     [8      -1:0]   lbp_data;
reg     [1      -1:0]   finish;
//=========================================================

always@(posedge clk or posedge reset) begin
    if (reset) begin
            gray_addr       <=  14'd0;
            gray_req        <=  1'd0;
            lbp_addr        <=  14'd0;
            lbp_valid       <=  1'd0;
            lbp_data        <=  8'd0;
            finish          <=  1'd0;

            gray_data_reg   <=  8'd0;
    end else if (!reset & gray_ready) begin
            gray_data_reg   <= gray_data;
    end
end








//====================================================================
endmodule
