vlib work
vlog spi_slave.v 
vlog sync_ram.v
vlog spi_wrapper.v
vlog spi_wrapper_tb.v
vsim -voptargs=+acc work.spi_wrapper_tb
add wave *
add wave -position insertpoint  \
sim:/spi_wrapper_tb/uut/spi_inst/rx_data \
sim:/spi_wrapper_tb/uut/spi_inst/rx_valid \
sim:/spi_wrapper_tb/uut/spi_inst/tx_data \
sim:/spi_wrapper_tb/uut/spi_inst/tx_valid \
sim:/spi_wrapper_tb/uut/spi_inst/state \
sim:/spi_wrapper_tb/uut/spi_inst/next_state \
sim:/spi_wrapper_tb/uut/ram_inst/wr_address \
sim:/spi_wrapper_tb/uut/ram_inst/rd_address
run -all
#quit -sim