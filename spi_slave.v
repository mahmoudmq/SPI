module spi_slave #(
    parameter IDLE = 3'b000,
    parameter READ_DATA = 3'b001,
    parameter READ_ADD = 3'b010,
    parameter CHK_CMD = 3'b011,
    parameter WRITE = 3'b100
)(
    input MOSI, // input from master
    input SS_n, // input from master
    input clk,
    input rst_n,
    output reg MISO, // output to master
    output reg [9:0] rx_data, // Data to Wrrite to RAM
    output reg rx_valid, // signal to indicate valid data write
    input [7:0] tx_data, // Data Read from RAM
    output reg tx_valid // signal to indicate valid data read
);
    (*fsm_encoding = "one-hot"*)
    reg [2:0] state;
    reg [2:0] next_state;
    integer read_transition = 0; // Counter to track read transitions
    integer counter = 10;

    // State Memory
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state = IDLE;
        else
            state = next_state;
    end

    // Next State Logic
    always @(state, SS_n, MOSI) begin
        case (state)
            IDLE: begin
                if (SS_n) begin
                    next_state = IDLE;
                end else begin
                    next_state = CHK_CMD;
                end
            end
            READ_DATA: begin
                if (SS_n) begin
                    next_state = IDLE;
                end else begin
                    next_state = READ_DATA;
                end
            end
            READ_ADD: begin
                if (SS_n) begin
                    next_state = IDLE;
                end else begin
                    next_state = READ_ADD;
                end
            end
            CHK_CMD: begin
                if (SS_n) begin
                    next_state = IDLE;
                end else begin
                    if (MOSI) begin
                        if (read_transition)
                            next_state = READ_DATA;
                        else
                            next_state = READ_ADD;
                    end else begin
                        next_state = WRITE;
                    end
                end
            end
            WRITE: begin
                if (SS_n) begin
                    next_state = IDLE;
                end else begin
                    next_state = WRITE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output Logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                MISO = 0;
                rx_data = 0;
                rx_valid = 0;
                tx_valid = 0;
            end
            READ_DATA: begin
                if (!SS_n) begin
                    counter = counter - 1;
                    rx_data[counter] = MOSI;
                    if (counter < 9) begin
                        MISO = tx_data[counter]; // Send data back to master
                    end
                    if (counter == 0) begin
                        tx_valid = 1; // Indicate that data is valid
                        counter = 10; // Reset counter for next transaction
                        read_transition = 0; // Reset read transition
                    end else begin
                        rx_valid = 0; // Data not yet valid
                    end
                end else begin
                    rx_valid = 0; // Reset valid signal if SS_n is high
                end

            end
            READ_ADD: begin
                if (!SS_n) begin
                    counter = counter - 1;
                    rx_data[counter] = MOSI;
                    if (counter == 0) begin
                        rx_valid = 1; // Indicate that data is valid
                        counter = 10; // Reset counter for next transaction
                        read_transition = 1;
                    end else begin
                        rx_valid = 0; // Data not yet valid
                    end
                end else begin
                    rx_valid = 0; // Reset valid signal if SS_n is high
                end 
            end
            WRITE: begin
                if (!SS_n) begin
                    counter = counter - 1;
                    rx_data[counter] = MOSI;
                    if (counter == 0) begin
                        rx_valid = 1; // Indicate that data is valid
                        counter = 10; // Reset counter for next transaction
                    end else begin
                        rx_valid = 0; // Data not yet valid
                    end
                end else begin
                    rx_valid = 0; // Reset valid signal if SS_n is high
                end 
            end
            default: begin
                MISO = 0;
            end
        endcase
    end

endmodule