**1.	PROJECT DESCRIPTION:**
This project implements a Serial Peripheral Interface (SPI) slave module integrated with a single-port asynchronous RAM. The system is designed to receive serial data from a master device, decode commands, and interact with memory for reading and writing operations. The goal is to simulate, synthesize, and implement a complete digital communication and memory management system on an FPGA platform.

**System Overview**
The design is composed of three primary components, shown in Figure 1:
**1.	SPI Slave Module:**
Handles communication with the SPI master, captures incoming serial data, and forwards it to the memory interface.
**2.	Single-Port Async RAM Module:**
A memory block that executes read and write operations based on encoded instructions in the SPI stream.
**3.	Top-Level System Integration Module:**
Connects the SPI and RAM blocks together and facilitates system-level operation.

**Module Interfaces:**
a.	SPI Slave Module
Signal |	Direction |	Width |	Description
clk	 | Input	| 1 bit |	System clock
rst_n	Input	1 bit	Active-low reset
SS_n	Input	1 bit	Slave Select from master
MOSI	Input	1 bit	Serial data from master
tx_data	Input	8 bit	Data received from RAM
tx_valid	Input	1 bit	Data validity indicator
MISO	Output	1 bit	Serial data to master
rx_data	Output	10 bit	Parallel data to be sent to RAM (from MOSI)
rx_valid	Output	1 bit	Indicates if rx_data is valid
