module spi_wrapper_tb();
    reg clk;
    reg rst_n;
    reg MOSI;
    reg SS_n;
    wire MISO;

    // Instantiate the SPI wrapper
    spi_wrapper uut (
        .clk(clk),
        .rst_n(rst_n),
        .MOSI(MOSI),
        .SS_n(SS_n),
        .MISO(MISO)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Testbench stimulus
    initial begin
        rst_n = 0;
        MOSI = 0;
        SS_n = 1;
        #10;
        rst_n = 1;
        // Write Address command
        $display("Starting write Address command... Address input: 0xF1");
        SS_n = 0;
        #10;
        MOSI = 0; // Write Address command
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 0;
        #10;
        MOSI = 0;
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        SS_n = 1; // End write Address command
        #20;
        // Self-Checking conditions
        if (uut.ram_inst.wr_address !== 8'hF1) begin
            $display("Error: Write address not set correctly.");
        end else begin
            $display("Write address set correctly to %h", uut.ram_inst.wr_address);
        end
        SS_n = 0; // Start Write command
        #10;
        MOSI = 0; // Write Data command
        #10;
        MOSI = 1;
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        SS_n = 1; // End Write Data command
        #20;
        // Self-Checking conditions
        if (uut.ram_inst.ram[uut.ram_inst.wr_address] !== 8'h77) begin
            $display("Error: Write data not set correctly.");
        end else begin
            $display("Write data set correctly to %h", uut.ram_inst.ram[uut.ram_inst.wr_address]);
        end
        SS_n = 0; // Start Read Address command
        #10;
        MOSI = 1; // Read Address command
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 0;
        #10;
        MOSI = 0;
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        SS_n = 1; // End Read Address command
        #20;

        // Self-Checking conditions
        if (uut.ram_inst.rd_address !== 8'hF1) begin
            $display("Error: Read address not set correctly.");
        end else begin
            $display("Read address set correctly to %h", uut.ram_inst.rd_address);
        end
        SS_n = 0; // Start Read command
        #10;
        MOSI = 1; // Read Data command
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        MOSI = 0;
        #10;
        MOSI = 0;
        #10;
        MOSI = 1;
        #10;
        MOSI = 1;
        #10;
        SS_n = 1; // End Read Data command
        #20;

        // Self-Checking conditions
        if (uut.ram_inst.dout !== 8'h77) begin
            $display("Error: Read data not set correctly. Reading %h instead of 77", uut.ram_inst.dout);
        end else begin
            $display("Read data set correctly to %h", uut.ram_inst.dout);
        end
        $finish; // End simulation
    end
endmodule