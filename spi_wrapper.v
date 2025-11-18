module spi_wrapper (
    input clk,
    input rst_n,
    input MOSI, // Master Out Slave In
    input SS_n, // Slave Select
    output MISO // Master In Slave Out
);
    wire [9:0] rx_data;
    wire rx_valid;
    wire [7:0] tx_data;
    wire tx_valid;
    // instantiate the SPI slave module
    spi_slave spi_inst (
        .MOSI(MOSI),
        .SS_n(SS_n),
        .clk(clk),
        .rst_n(rst_n),
        .MISO(MISO),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .tx_data(tx_data),
        .tx_valid(tx_valid)
    );
    // instantiate the RAM module
    ram ram_inst (
        .clk(clk),
        .rst_n(rst_n),
        .din(rx_data),
        .rx_valid(rx_valid),
        .dout(tx_data),
        .tx_valid(tx_valid)
    );

endmodule