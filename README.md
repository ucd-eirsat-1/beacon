# EIRSAT-1 Beacons (and other data)

## Downlink

EIRSAT-1 downlinks data to Earth in the UHF amateur band at 437.1 MHz. This frequency has been coordinated by the [International Amateur Radio Union](http://www.amsatuk.me.uk/iaru/finished_detail.php?serialnum=639).

### The Technical Standards Stuff
The downlink is GMSK modulated at a data rate of 9600bps. Downlinked data is made up of PUS (Packet Utilisation Standard) packets contained in CCSDS (Consultative Committee on Space Data Systems) frames. The frames are 892 bytes long but are Reed-Solomon encoded with a dual basis and an interleaving depth of 4. A CCSDS scrambler is used on the frame and Reed-Solomon bytes to help clock-recovery of the signal on the ground.

This means that EIRSAT-1 transmits a CCSDS-standard 4-byte ASM (Attached Synchronisation Marker) of 1ACFFC1D, followed by the 892 bytes of the CCSDS frame, followed by 128 bytes of Reed-Solomon Forward Error Correcting bytes, for a total of 1024 bytes.

EIRSAT-1 also supports convolutional (also known as Viterbi) encoding and will launch with this enabled. Convolutional encoding improves the Bit Error Rate but halves the data throughput, so once the link budget has been demonstrated to have positive margin on orbit, convolutional encoding will be disabled. The polynomials used in the encoding are [79, 109]. Note that this is similar to the CCSDS specification but the second polynominal is not inverted as it should be in the CCSDS spec.

### I don't understand any of that!

That's okay! When we started building EIRSAT-1 we didn't understand any of that stuff either!

As we developed the EIRSAT-1 Ground Station, we relied heavily on [GNU Radio](https://www.gnuradio.org/) and in particular, the excellent [gr-satellites](https://gr-satellites.readthedocs.io/) module. The result is that we can express the full knowledge required to decode an EIRSAT-1 downlink signal into a single file known as a SatYAML file which gr-satellites can use. You'll find this file in the SatYAML folder.



## Packet Types

As mentioned above, EIRSAT-1 uses PUS packets. This is a standard for the packet structure used by satellites and it defines many different types of packets that a satellite can transmit. EIRSAT-1 uses a small subset of these packet types.

| PUS Type                         | Purpose                                   | Activity                                 |
| -------------------------------- | ----------------------------------------- | ---------------------------------------- |
| Housekeeping                     | Beacons                                   | Autonomous                               |
| Large Data Transfer (LDT)        | Downlinking data from on-board storage    | In response to commands                  |
| Event Reporting Service          | Transmit on-board 'events' as they occur  | Only active during a Ground Station pass |
| Telecommand Verification Service | Report success or failure of telecommands | In response to commands                  |
| Mission Specific Service         | Access on-board parameters                | In response to commands                  |


## Beacons

EIRSAT-1 has several beacon types:

| ID | Name               | Purpose |
|:--:| ------------------ | ------- |
|  0 | Failsafe           | Transmitted by the Failsafe software image                                 |
|  2 | Primary            | Transmitted by the Primary software image                                  |
|  3 | Primary (in-pass)  | Transmitted by the Primary software image during a Ground Station pass     |
|  4 | GMOD Spectrum      | Transmitted by the Primary software image after a GRB trigger has occurred |
|  5 | GMOD Lightcurve    | Transmitted by the Primary software image after a GRB trigger has occurred |

In most scenarios, EIRSAT-1 will be transmitting Beacon type 2 - the Primary software image will be active and EIRSAT-1 will not be within range of a Ground Station. If you live in Western Europe, you might observe EIRSAT-1 while it's in range of a Ground Station so you could also often see Beacon type 3 aswell as a lot of other packet types, particularly LDTs. If you live in Dublin, you will probably never see Beacon type 2! You'll see all the same data that the EIRSAT-1 team is getting from the Ground Station.


# Recordings

The 'Recordings' folder contains several recordings of the satellite beacon in different configurations. The recordings have been made using an RTLSDR software defined radio and FM demodulated. It also contains text files, one frame per line, with the expected data bytes for each recording. Note: these recordings do need to be played back with a gain of -1 in gr-satellites.

| Filename                  | Description | Beacons in Recording |
| ------------------------- | ----------- |:-:|
| primary_no_conv.wav       | Beacons transmitted by the Primary software image with convolutional encoding disabled  | 3 |
| primary_conv_enabled.wav  | Beacons transmitted by the Primary software image with convolutional encoding enabled   | 4 |
| failsafe_no_conv.wav      | Beacons transmitted by the Failsafe software image with convolutional encoding disabled | 3 |
| failsafe_conv_enabled.wav | Beacons transmitted by the Failsafe software image with convolutional encoding enabled  | 2 |
