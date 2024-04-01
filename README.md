# eBPF_SoftCore_BSc

7 years overdue, I have decided to open-source my bachelor's thesis titled **"FPGA implementation of the (extended) Berkeley Packet Filter (BPF)"**.

The aim was to develop a proof-of-concept soft core processor, based on [eBPF](https://en.wikipedia.org/wiki/EBPF), that could be deployed on an FPGA platform ([NetFPGA](https://netfpga.org/)). This can be used for high-speed packet filtering in e.g. data centres. The project proved too Ambitious for a Bachelor's thesis, but still produced several valuable contributions such as an eBPF emulator, a proposed soft core architecture, timing and fabric consumption analysis (done in Vivado), amongst others.

The project consists of 3 parts:
* An eBPF emulator - this can execute simple eBPF programs and was written to help with learning the instruction set. It is a higher-level description of a soft core. This was originally developed in Netbeans on Linux.
* Soft Core IP - the HDL (Verilog) for the soft core processor. This was initially developed using Icarus Verilog on Linux. Then synthesized and analyzed using Vivado.
* The writeup - this contains the final version of the thesis as PDF.

**Note:** Currently, there is no plan to look into improving/optimizing the source code. It will be left as written 7+ years ago.
