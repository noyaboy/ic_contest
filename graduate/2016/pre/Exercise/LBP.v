
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

//====================================================================

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

reg     [14     -1:0]   gray_addr;
reg     [1      -1:0]   gray_req;
reg     [14     -1:0]   lbp_addr;
reg     [1      -1:0]   lbp_valid;
reg     [8      -1:0]   lbp_data;
reg     [1      -1:0]   finish;

reg     [8      -1:0]   gray_data_regfile_0   [126      -1:0];
/*  00_1[000_0001]  ->  00_1[111_1110]
    10_0[000_0001]  ->  10_0[111_1110]    */
reg     [8      -1:0]   gray_data_regfile_1   [126      -1:0];
/*  01_0[000_0001]  ->  01_0[111_1110]
    10_1[000_0001]  ->  10_1[111_1110]    */
reg     [8      -1:0]   gray_data_regfile_2   [126      -1:0];
/*  01_1[000_0001]  ->  01_1[111_1110] 
    11_0[000_0001]  ->  11_0[111_1110]    */
reg     [2      -1:0]   gray_data_sel_regfile;

wire    [14     -1:0]   gray_addr_nxt;
wire    [2      -1:0]   gray_data_sel_regfile_nxt;

//=========================================================

assign  gray_addr_nxt               =   ( !gray_addr[0] & ( &gray_addr[6:1] ) )?    
                                        gray_addr + 3:
                                        gray_addr + 1;

assign  gray_data_sel_regfile_nxt   =   ( ( !gray_addr[0] & ( &gray_addr[6:1] ) ) & (gray_data_sel_regfile == 2'd2) )?    
                                        2'd0:
                                        ( !gray_addr[0] & ( &gray_addr[6:1] ) )?
                                        gray_data_sel_regfile + 1: 
                                        gray_data_sel_regfile;

//=========================================================

always@(posedge clk or posedge reset) begin
        if (reset) begin
                gray_req        <=  1'd0;
        end else if (!gray_req & (gray_ready & !finish)) begin
                gray_req        <=  1'b1;
        end else if (gray_req & (!gray_ready | finish)) begin
                gray_req        <=  1'b0;
        end
end

always@(posedge clk or posedge reset) begin
    if (reset) begin
        gray_addr               <=  14'd129;
        gray_data_sel_regfile   <=  2'd0;
    end else if (gray_req) begin
        gray_addr               <=  gray_addr_nxt;
        gray_data_sel_regfile   <=  gray_data_sel_regfile_nxt;
    end
end

always@(posedge clk or posedge reset) begin
    if (reset) begin
            lbp_valid           <=  1'd0;
            finish              <=  1'd0;
    end 
end

always@(posedge clk) begin
        if (gray_req && gray_data_sel_regfile == 2'd0) begin
                gray_data_regfile_0[gray_addr[6:0] - 1]     <=  gray_data;
        end else if (gray_req && gray_data_sel_regfile == 2'd1) begin
                gray_data_regfile_1[gray_addr[6:0] - 1]     <=  gray_data;
        end else if (gray_req && gray_data_sel_regfile == 2'd2) begin
                gray_data_regfile_2[gray_addr[6:0] - 1]     <=  gray_data;
        end 
end

//====================================================================
endmodule
