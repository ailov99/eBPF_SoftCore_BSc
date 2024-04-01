This is the HDL IP design for the eBPF soft core.

## To run

TODO

## Architecture

### Full system diagram
<img src="media/full_diagram.png" width="900" height="800">

### Component diagrams

#### ALU

<img src="media/alu_diagram.png" width="500" height="300">

#### Decoder

<img src="media/decoder_diagram.png" width="500" height="250">

#### IR

<img src="media/ir_tristate.png" width="300" height="300">

#### PC

<img src="media/pc_diagram.png" width="450" height="350">

#### Memory

<img src="media/mem_diagram.png" width="500" height="300">

#### Register bank

<img src="media/reg_bank_diagram.png" width="500" height="300">

## Operation and deployment

#### Fetch -> Decode -> Increment SM

<img src="media/fetch_dec_inc.png" width="500" height="500">

#### Synthesis report (Virtex 5)

<img src="media/synthesis_report_virtex5.png" width="700" height="200">