meta:
  id: eirsat
  file-extension: bin


seq:
  - id: frame_contents
    size: 892
    type: ccsds_frame


types:

  ccsds_frame:
    seq:
      - id: header
        type: ccsds_header
      - id: packets
        type: pus_pkt
        repeat: eos
 

  ccsds_header:
    meta:
      bit-endian: be
    seq:
      - id: version_no
        type: b2
      - id: sc_id
        type: b10
      - id: vc_id
        type: b3
      - id: ocf
        type: b1
      - id: mc_count
        type: u1
      - id: vc_count
        type: u1
      - id: sec_hdr_flag
        type: b1
      - id: sync_flag
        type: b1
      - id: pkt_order_flag
        type: b1
      - id: seg_len_id
        type: b2
      - id: first_hdr_pointer
        type: b11


  pus_pkt:
    seq:
      - id: header
        type: pus_hdr
      - id: data_field
        type: pus_data_field
        size: header.packet_data_len - 1
      - id: packet_error_control
        size: 2


  pus_hdr:
    seq:
      - id: version_no
        type: b3
      - id: type_indicator
        type: b1
        enum: tmtc
      - id: sec_hdr_flag
        type: b1
      - id: apid
        type: b11
      - id: grouping_flags
        type: b2
      - id: src_seq
        type: b14
      - id: packet_data_len
        type: u2be
          
    enums:
      tmtc:
        0: tm
        1: tc
  
  
  pus_data_field:
    seq:
      - id: sec_hdr
        type:
          switch-on: _parent.header.type_indicator
          cases:
            pus_hdr::tmtc::tm: tm_sec_hdr
            pus_hdr::tmtc::tc: tc_sec_hdr
      - id: service
        type: u1
      - id: subservice
        type: u1
      - id: data
        type:
          switch-on: (service << 8) + subservice
          cases:
            0x319: housekeeping


  tm_sec_hdr:
    meta:
      bit-endian: be
    seq:
      - id: pus_version
        type: b4


  tc_sec_hdr:
    meta:
      bit-endian: be
    seq:
      - id: pus_version
        type: b4
      - id: ack
        type: b4


  housekeeping:
    seq:
      - id: hk_structure_id
        type: u1
      - id: hk_data
        size-eos: true
        type:
          switch-on: hk_structure_id
          cases:
            0: hk_struct_00
            2: hk_struct_02


  hk_struct_00:
    meta:
      bit-endian: be
    seq:
      - id: version_satellitestring_0
        type: str
        encoding: ascii
        size: 8
        doc: |
          Fixed "EIRSAT-1" string.

      - id: version_messagestring_0
        type: str
        encoding: ascii
        size: 32
        doc: |
          Variable message string.

      - id: core_obt_time_0
        type: b32
        doc: |
          uint32: Time in seconds since first power on, i.e. Mission Elapsed Time.

      - id: core_obt_uptime_0
        type: b32
        doc: |
          uint32: Time in seconds since last boot, i.e. Uptime. 

      - id: mission_separationsequence_state_0
        type: b8
        doc: |
          uint8: State of the separation sequence state machine.
            0: Init
            1: Post-launch Wait
            2: -Y Primary Burn Start
            3: +Y Primary Burn Start
            4: -X Primary Burn Start
            5: +X Primary Burn Start
            6: Burning
            7: Burn Off
            8: Between Burn Wait
            9: Secondary Burn Wait
            66: Complete

      - id: mission_separationsequence_antswitchesstatuses_0_3_uhf_minusy
        type: b1
        doc: |
          bool: -Y UHF Antenna Deployed.

      - id: mission_separationsequence_antswitchesstatuses_0_2_vhf_minusx
        type: b1
        doc: |
          bool: -X VHF Antenna Deployed.

      - id: mission_separationsequence_antswitchesstatuses_0_1_uhf_plusy
        type: b1
        doc: |
          bool: +Y UHF Antenna Deployed.

      - id: mission_separationsequence_antswitchesstatuses_0_0_vhf_plusx
        type: b1
        doc: |
          bool: +X VHF Antenna Deployed.

      - id: platform_obc_obc_currbootimage_0
        type: b8
        doc: |
          uint8: Current OBC Image.
            0: Failsafe
            1: Primary 1
            2: Primary 2

      - id: comms_hmac_sequencenumber_0
        type: b24
        doc: |
          uint24: HMAC Sequence expected for next TC.

      - id: platform_bat_batterycurrent_2
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Current.
            Value in mA = ADC * 14.662757

      - id: platform_bat_batteryvoltage_2
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Voltage.
            Value in V = ADC * 0.008993

      - id: platform_bat_batterytemperature_0
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Pair 1 Temparature.
            Value in *C = ADC * 0.3976 - 238.57

      - id: platform_bat_batterytemperature_1
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Pair 2 Temparature.
            Value in *C = ADC * 0.3976 - 238.57

      - id: platform_bat_batterytemperature_2
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Pair 3 Temparature.
            Value in *C = ADC * 0.3976 - 238.57

      - id: platform_bat_batterycurrentdir_0
        type: b1
        doc: |
          bool: Battery Current Direction.
            True: Battery is charging.
            Flase: Battery is discharging.

      - id: platform_bat_packedheaterstatus_0
        type: b1
        doc: |
          bool: Battery Cell Pair 1 Heater On.

      - id: platform_bat_packedheaterstatus_1
        type: b1
        doc: |
          bool: Battery Cell Pair 2 Heater On.

      - id: platform_bat_packedheaterstatus_2
        type: b1
        doc: |
          bool: Battery Cell Pair 3 Heater On.

      - id: platform_eps_actualswitchstatesbitmap_0_9
        type: b1
        doc: |
          bool: EMOD 3.3V Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_8
        type: b1
        doc: |
          bool: GMOD 3.3V Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_7
        type: b1
        doc: |
          bool: Fine Sun Sensor Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_6
        type: b1
        doc: |
          bool: Switch 7 is On.

      - id: platform_eps_actualswitchstatesbitmap_0_5
        type: b1
        doc: |
          bool: GMOD 5V is On.

      - id: platform_eps_actualswitchstatesbitmap_0_4
        type: b1
        doc: |
          bool: Switch 5 Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_3
        type: b1
        doc: |
          bool: Switch 4 is On.

      - id: platform_eps_actualswitchstatesbitmap_0_2
        type: b1
        doc: |
          bool: GMOD BatV Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_1
        type: b1
        doc: |
          bool: ADM Secondary Resistors Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_0
        type: b1
        doc: |
          bool: ADM Primary Resistors Switch is On.

      - id: platform_eps_switchovercurrentbitmap_0_9
        type: b1
        doc: |
          bool: EMOD 3.3V triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_8
        type: b1
        doc: |
          bool: GMOD 3.3V triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_7
        type: b1
        doc: |
          bool: Fine Sun Sensor triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_6
        type: b1
        doc: |
          bool: Switch 7 triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_5
        type: b1
        doc: |
          bool: GMOD 5V triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_4
        type: b1
        doc: |
          bool: Switch 5 triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_3
        type: b1
        doc: |
          bool: Switch 4 triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_2
        type: b1
        doc: |
          bool: GMOD BatV triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_1
        type: b1
        doc: |
          bool: ADM Secondary Resistors triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_0
        type: b1
        doc: |
          bool: ADM Primary Resistors triggered Over-current Protection.

      - id: platform_eps_board_temperature_0
        type: b10
        doc: |
          uint10: ADC value for EPS Board Temparature.
            Value in *C = ADC * 0.372434 - 273.15

      - id: platform_eps_bus_voltages_0_battery
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in V = ADC * 0.008978

      - id: platform_eps_bus_voltages_1_3v3
        type: b10
        doc: |
          uint10: ADC value for 3.3V Bus Voltage.
            Value in V = ADC * 0.004311

      - id: platform_eps_bus_voltages_2_5v
        type: b10
        doc: |
          uint10: ADC value for 5V Bus Voltage.
            Value in V = ADC * 0.005865

      - id: platform_eps_bus_voltages_3_12v
        type: b10
        doc: |
          uint10: ADC value for 12V Bus Voltage.
            Value in V = ADC * 0.01349

      - id: platform_eps_bus_currents_0_battery
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.005237

      - id: platform_eps_bus_currents_1_3v3
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.005237

      - id: platform_eps_bus_currents_2_5v
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.005237

      - id: platform_eps_bus_currents_3_12v
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.00207

      - id: platform_adcs_array_temperature_1_plusx
        type: b16
        doc: |
          uint10: ADC value for +X Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_adcs_array_temperature_4_minusx
        type: b16
        doc: |
          uint10: ADC value for -X Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_adcs_array_temperature_3_plusy
        type: b16
        doc: |
          uint10: ADC value for +Y Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_adcs_array_temperature_2_minusy
        type: b16
        doc: |
          uint10: ADC value for -Y Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_eps_solar_array_currents_1_plusx
        type: b10
        doc: |
          uint10: ADC value for +X Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_currents_4_minusx
        type: b10
        doc: |
          uint10: ADC value for -X Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_currents_3_plusy
        type: b10
        doc: |
          uint10: ADC value for +Y Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_currents_2_minusy
        type: b10
        doc: |
          uint10: ADC value for -Y Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_voltages_0
        type: b10
        doc: |
          uint10: ADC value for Battery Charge Regulator 1.
            Value in V = ADC * 0.0322581

      - id: platform_eps_solar_array_voltages_1
        type: b10
        doc: |
          uint10: ADC value for Battery Charge Regulator 1.
            Value in V = ADC * 0.0322581

      - id: platform_eps_solar_array_voltages_2
        type: b10
        doc: |
          uint10: ADC value for Battery Charge Regulator 1.
            Value in V = ADC * 0.0099706

      - id: platform_adcs_packedadcsmode_0
        type: b8
        doc: |
          uint8: State of the separation sequence state machine.
            0: Standby
            1: Detumble
            2: Stabilised
            85: Test

      - id: platform_adcs_executioncount_0
        type: b16
        doc: |
          uint16: Execution Count of the ADCS Algorithm.

      - id: platform_adcs_rawgyrorate_0
        type: b16
        doc: |
          sint16: ADC value for the X-Axis Gyro Rate.
            Value in degrees / s = ADC * -0.0104166

      - id: platform_adcs_rawgyrorate_1
        type: b16
        doc: |
          sint16: ADC value for the Y-Axis Gyro Rate.
            Value in degrees / s = ADC * -0.0104166

      - id: platform_adcs_rawgyrorate_2
        type: b16
        doc: |
          sint16: ADC value for the Z-Axis Gyro Rate.
            Value in degrees / s = ADC * -0.0104166

      - id: platform_adcs_fss1alphaangle_0
        type: b32
        doc: |
          float32: Fine Sun Sensor off-axis Alpha angle of Sun. 

      - id: platform_adcs_fss1betaangle_0
        type: b32
        doc: |
          float32: Fine Sun Sensor off-axis Beta angle of Sun. 
 
      - id: platform_cmc_mode_0
        type: b2
        doc: |
          uint2: Mode of the CMC Transceiver.
            1: Downlink: GMSK 9600, Uplink AFSK 1200 (Used by EIRSAT-1)
            2: Downlink: AFSK 1200, Uplink GMSK 9600
            3: Downlink: GMSK 9600, Uplink GMSK 9600
 
      - id: platform_cmc_beaconenable_0
        type: b1
        doc: |
          bool: CMC Autonomous Hardware Beacon is armed and will commence transmission if i2c communication with OBC ceases.
 
      - id: platform_cmc_txtransparent_0
        type: b1
        doc: |
          bool: AX.25 framing is enabled on Downlink.

      - id: platform_cmc_txconvenabled_0
        type: b1
        doc: |
          bool: Convolutional Encoding is being used.

      - id: platform_cmc_txpower_0
        type: b2
        doc: |
          uint2: Transmit power.
            0: 0.5W (27dBm)
            1: 1W (30dBm)
            2: 2W (33dBm)
 
      - id: platform_cmc_rxlock_0
        type: b1
        doc: |
          bool: RX local oscillator PLL in locked.

      - id: platform_cmc_rxrssi_0
        type: b12
        doc: |
          uint12: Received Signal Strength Indicator in arbitrary units.

      - id: platform_cmc_rxfrequencyoffset_0
        type: b10
        doc: |
          uint10: DAC Value of RX Frequency VFO.
            Value in MHz = DAC * 0.0125 + 140

      - id: platform_cmc_rxpacketcount_0
        type: b16
        doc: |
          uint16: Received Packet Count.

      - id: platform_cmc_temperaturepa_0
        type: b8
        doc: |
          sint8: TX Power Amplifier Temperature in *C.

      - id: platform_cmc_current5v_0
        type: b16
        doc: |
          sint16: ADC Value for the Transceiver Current on the 5V bus.
            Value in A = ADC * 0.000062

      - id: platform_cmc_voltage5v_0
        type: b13
        doc: |
          uint13: ADC Value for the Transceiver Voltage on the 5V bus.
            Value in V = ADC * 0.004

      - id: platform_cmc_rxcrcerrorcount_0
        type: b16
        doc: |
          uint16: Count of received packets with invalid CRC.

      - id: core_eventdispatcher_eventcount_0
        type: b32
        doc: |
          uint32: Count of Events recorded by OBC.

      - id: core_eventdispatcher_lastevent_0_severity
        type: b2
        doc: |
          uint2: Last Event Severity.

      - id: core_eventdispatcher_lastevent_0_event_id
        type: b14
        doc: |
          uint14: Last Event ID.

      - id: core_eventdispatcher_lastevent_0_event_source_id
        type: b16
        doc: |
          uint16: Last Event Source ID.

      - id: core_eventdispatcher_lastevent_0_info
        type: b32
        doc: |
          uint32: Information attached to Last Event.

      - id: padding
        type: b7


  hk_struct_02:
    meta:
      endian: be
      bit-endian: be
    seq:
      - id: version_satellitestring_0
        type: str
        encoding: ascii
        size: 8
        doc: |
          Fixed "EIRSAT-1" string.

      - id: version_messagestring_0
        type: str
        encoding: ascii
        size: 32
        doc: |
          Variable message string.

      - id: core_obt_time_0
        type: b32
        doc: |
          uint32: Time in seconds since first power on, i.e. Mission Elapsed Time.

      - id: core_obt_uptime_0
        type: b32
        doc: |
          uint32: Time in seconds since last boot, i.e. Uptime.

      - id: mission_modemanager_mode_0
        type: b4
        doc: |
          uint4: Satellite Mode.
            0: Separation
            1: Commissioning
            2: Nominal
            3: WBC
            4: SAFE

      - id: mission_separationsequence_state_0
        type: b8
        doc: |
          uint8: State of the separation sequence state machine.
            0: Init
            1: Post-launch Wait
            2: -Y Primary Burn Start
            3: +Y Primary Burn Start
            4: -X Primary Burn Start
            5: +X Primary Burn Start
            6: Burning
            7: Burn Off
            8: Between Burn Wait
            9: Secondary Burn Wait
            66: Complete

      - id: mission_separationsequence_antswitchesstatuses_0_3_uhf_minusy
        type: b1
        doc: |
          bool: -Y UHF Antenna Deployed.

      - id: mission_separationsequence_antswitchesstatuses_0_2_vhf_minusx
        type: b1
        doc: |
          bool: -X VHF Antenna Deployed.

      - id: mission_separationsequence_antswitchesstatuses_0_1_uhf_plusy
        type: b1
        doc: |
          bool: +Y UHF Antenna Deployed.

      - id: mission_separationsequence_antswitchesstatuses_0_0_vhf_plusx
        type: b1
        doc: |
          bool: +X VHF Antenna Deployed.

      - id: platform_obc_obc_currbootimage_0
        type: b8
        doc: |
          uint8: Current OBC Image.
            0: Failsafe
            1: Primary 1
            2: Primary 2

      - id: comms_hmac_sequencenumber_0
        type: b24
        doc: |
          uint24: HMAC Sequence expected for next TC.

      - id: platform_obc_telemetryadcb_channeloutput_7_obctemperature
        type: b12
        doc: |
          uint10: ADC value for OBC Board Temparature.
            Value in *C = ADC * 0.048828 - 60

      - id: platform_obc_gps_lastvalidstatevec_0_locktime
        type: b32
        doc: |
          uint32: Onboard Time (nominally MET) of last valid State Vector.
            Value is in seconds.

      - id: platform_obc_gps_lastvalidstatevec_0_lockfinetime
        type: b32
        doc: |
          uint32: Fractional part of Onboard Time (nominally MET) of last valid State Vector.
            Value is in 1/(2^32) of a second.

      - id: platform_obc_gps_lastvalidstatevec_0_ecefpositionx
        type: b32
        doc: |
          float32: ECEF (Earth-Centred, Earth-Fixed) X-coordinate of position.

      - id: platform_obc_gps_lastvalidstatevec_0_ecefpositiony
        type: b32
        doc: |
          float32: ECEF (Earth-Centred, Earth-Fixed) Y-coordinate of position.

      - id: platform_obc_gps_lastvalidstatevec_0_ecefpositionz
        type: b32
        doc: |
          float32: ECEF (Earth-Centred, Earth-Fixed) Z-coordinate of position.

      - id: platform_obc_gps_lastvalidstatevec_0_ecefvelocityx
        type: b32
        doc: |
          float32: ECEF (Earth-Centred, Earth-Fixed) X-component of velocity.

      - id: platform_obc_gps_lastvalidstatevec_0_ecefvelocityy
        type: b32
        doc: |
          float32: ECEF (Earth-Centred, Earth-Fixed) Y-component of velocity.

      - id: platform_obc_gps_lastvalidstatevec_0_ecefvelocityz
        type: b32
        doc: |
          float32: ECEF (Earth-Centred, Earth-Fixed) Z-component of velocity.

      - id: platform_obc_gps_lastvalidstatevec_0_hours
        type: b8
        doc: |
          uint8: Hour (UTC) of last valid State Vector.

      - id: platform_obc_gps_lastvalidstatevec_0_minutes
        type: b8
        doc: |
          uint8: Minute (UTC) of last valid State Vector.

      - id: platform_obc_gps_lastvalidstatevec_0_seconds
        type: b8
        doc: |
          uint8: Second (UTC) of last valid State Vector.

      - id: platform_obc_gps_lastvalidstatevec_0_milliseconds
        type: b16
        doc: |
          uint16: Millisecond (UTC) of last valid State Vector.

      - id: platform_bat_batterycurrent_2
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Current.
            Value in mA = ADC * 14.662757

      - id: platform_bat_batteryvoltage_2
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Voltage.
            Value in V = ADC * 0.008993

      - id: platform_bat_batterytemperature_0
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Pair 1 Temparature.
            Value in *C = ADC * 0.3976 - 238.57

      - id: platform_bat_batterytemperature_1
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Pair 2 Temparature.
            Value in *C = ADC * 0.3976 - 238.57

      - id: platform_bat_batterytemperature_2
        type: b10
        doc: |
          uint10: ADC value for Battery Cell Pair 3 Temparature.
            Value in *C = ADC * 0.3976 - 238.57

      - id: platform_bat_batterycurrentdir_0
        type: b1
        doc: |
          bool: Battery Current Direction.
            True: Battery is charging.
            Flase: Battery is discharging.

      - id: platform_bat_packedheaterstatus_0
        type: b1
        doc: |
          bool: Battery Cell Pair 1 Heater On.

      - id: platform_bat_packedheaterstatus_1
        type: b1
        doc: |
          bool: Battery Cell Pair 2 Heater On.

      - id: platform_bat_packedheaterstatus_2
        type: b1
        doc: |
          bool: Battery Cell Pair 3 Heater On.

      - id: platform_eps_actualswitchstatesbitmap_0_9
        type: b1
        doc: |
          bool: EMOD 3.3V Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_8
        type: b1
        doc: |
          bool: GMOD 3.3V Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_7
        type: b1
        doc: |
          bool: Fine Sun Sensor Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_6
        type: b1
        doc: |
          bool: Switch 7 is On.

      - id: platform_eps_actualswitchstatesbitmap_0_5
        type: b1
        doc: |
          bool: GMOD 5V is On.

      - id: platform_eps_actualswitchstatesbitmap_0_4
        type: b1
        doc: |
          bool: Switch 5 Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_3
        type: b1
        doc: |
          bool: Switch 4 is On.

      - id: platform_eps_actualswitchstatesbitmap_0_2
        type: b1
        doc: |
          bool: GMOD BatV Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_1
        type: b1
        doc: |
          bool: ADM Secondary Resistors Switch is On.

      - id: platform_eps_actualswitchstatesbitmap_0_0
        type: b1
        doc: |
          bool: ADM Primary Resistors Switch is On.

      - id: platform_eps_switchovercurrentbitmap_0_9
        type: b1
        doc: |
          bool: EMOD 3.3V triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_8
        type: b1
        doc: |
          bool: GMOD 3.3V triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_7
        type: b1
        doc: |
          bool: Fine Sun Sensor triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_6
        type: b1
        doc: |
          bool: Switch 7 triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_5
        type: b1
        doc: |
          bool: GMOD 5V triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_4
        type: b1
        doc: |
          bool: Switch 5 triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_3
        type: b1
        doc: |
          bool: Switch 4 triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_2
        type: b1
        doc: |
          bool: GMOD BatV triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_1
        type: b1
        doc: |
          bool: ADM Secondary Resistors triggered Over-current Protection.

      - id: platform_eps_switchovercurrentbitmap_0_0
        type: b1
        doc: |
          bool: ADM Primary Resistors triggered Over-current Protection.

      - id: platform_eps_board_temperature_0
        type: b10
        doc: |
          uint10: ADC value for EPS Board Temparature.
            Value in *C = ADC * 0.372434 - 273.15

      - id: platform_eps_bus_voltages_0_battery
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in V = ADC * 0.008978

      - id: platform_eps_bus_voltages_1_3v3
        type: b10
        doc: |
          uint10: ADC value for 3.3V Bus Voltage.
            Value in V = ADC * 0.004311

      - id: platform_eps_bus_voltages_2_5v
        type: b10
        doc: |
          uint10: ADC value for 5V Bus Voltage.
            Value in V = ADC * 0.005865

      - id: platform_eps_bus_voltages_3_12v
        type: b10
        doc: |
          uint10: ADC value for 12V Bus Voltage.
            Value in V = ADC * 0.01349

      - id: platform_eps_bus_currents_0_battery
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.005237

      - id: platform_eps_bus_currents_1_3v3
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.005237

      - id: platform_eps_bus_currents_2_5v
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.005237

      - id: platform_eps_bus_currents_3_12v
        type: b10
        doc: |
          uint10: ADC value for BatV Bus Voltage.
            Value in A = ADC * 0.00207

      - id: platform_adcs_array_temperature_1_plusx
        type: b16
        doc: |
          uint10: ADC value for +X Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_adcs_array_temperature_4_minusx
        type: b16
        doc: |
          uint10: ADC value for -X Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_adcs_array_temperature_3_plusy
        type: b16
        doc: |
          uint10: ADC value for +Y Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_adcs_array_temperature_2_minusy
        type: b16
        doc: |
          uint10: ADC value for -Y Solar Array Temparature.
            Value in *C = ADC * 0.007629 - 272.15

      - id: platform_eps_solar_array_currents_1_plusx
        type: b10
        doc: |
          uint10: ADC value for +X Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_currents_4_minusx
        type: b10
        doc: |
          uint10: ADC value for -X Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_currents_3_plusy
        type: b10
        doc: |
          uint10: ADC value for +Y Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_currents_2_minusy
        type: b10
        doc: |
          uint10: ADC value for -Y Solar Array Current.
            Value in A = ADC * 0.0009775

      - id: platform_eps_solar_array_voltages_0
        type: b10
        doc: |
          uint10: ADC value for Battery Charge Regulator 1.
            Value in V = ADC * 0.0322581

      - id: platform_eps_solar_array_voltages_1
        type: b10
        doc: |
          uint10: ADC value for Battery Charge Regulator 1.
            Value in V = ADC * 0.0322581

      - id: platform_eps_solar_array_voltages_2
        type: b10
        doc: |
          uint10: ADC value for Battery Charge Regulator 1.
            Value in V = ADC * 0.0099706

      - id: platform_adcs_packedadcsmode_0
        type: b8
        doc: |
          uint8: State of the separation sequence state machine.
            0: Standby
            1: Detumble
            2: Stabilised
            85: Test

      - id: platform_adcs_executioncount_0
        type: b16
        doc: |
          uint16: Execution Count of the ADCS Algorithm.

      - id: platform_adcs_rawgyrorate_0
        type: b16
        doc: |
          sint16: ADC value for the X-Axis Gyro Rate.
            Value in degrees / s = ADC * -0.0104166

      - id: platform_adcs_rawgyrorate_1
        type: b16
        doc: |
          sint16: ADC value for the Y-Axis Gyro Rate.
            Value in degrees / s = ADC * -0.0104166

      - id: platform_adcs_rawgyrorate_2
        type: b16
        doc: |
          sint16: ADC value for the Z-Axis Gyro Rate.
            Value in degrees / s = ADC * -0.0104166

      - id: platform_adcs_fss1alphaangle_0
        type: b32
        doc: |
          float32: Fine Sun Sensor off-axis Alpha angle of Sun. 

      - id: platform_adcs_fss1betaangle_0
        type: b32
        doc: |
          float32: Fine Sun Sensor off-axis Beta angle of Sun. 
 
      - id: platform_cmc_mode_0
        type: b2
        doc: |
          uint2: Mode of the CMC Transceiver.
            1: Downlink: GMSK 9600, Uplink AFSK 1200 (Used by EIRSAT-1)
            2: Downlink: AFSK 1200, Uplink GMSK 9600
            3: Downlink: GMSK 9600, Uplink GMSK 9600
 
      - id: platform_cmc_beaconenable_0
        type: b1
        doc: |
          bool: CMC Autonomous Hardware Beacon is armed and will commence transmission if i2c communication with OBC ceases.
 
      - id: platform_cmc_txtransparent_0
        type: b1
        doc: |
          bool: AX.25 framing is enabled on Downlink.

      - id: platform_cmc_txconvenabled_0
        type: b1
        doc: |
          bool: Convolutional Encoding is being used.

      - id: platform_cmc_txpower_0
        type: b2
        doc: |
          uint2: Transmit power.
            0: 0.5W (27dBm)
            1: 1W (30dBm)
            2: 2W (33dBm)
 
      - id: platform_cmc_rxlock_0
        type: b1
        doc: |
          bool: RX local oscillator PLL in locked.

      - id: platform_cmc_rxrssi_0
        type: b12
        doc: |
          uint12: Received Signal Strength Indicator in arbitrary units.

      - id: platform_cmc_rxfrequencyoffset_0
        type: b10
        doc: |
          uint10: DAC Value of RX Frequency VFO.
            Value in MHz = DAC * 0.0125 + 140

      - id: platform_cmc_rxpacketcount_0
        type: b16
        doc: |
          uint16: Received Packet Count.

      - id: platform_cmc_temperaturepa_0
        type: b8
        doc: |
          sint8: TX Power Amplifier Temperature in *C.

      - id: platform_cmc_current5v_0
        type: b16
        doc: |
          sint16: ADC Value for the Transceiver Current on the 5V bus.
            Value in A = ADC * 0.000062

      - id: platform_cmc_voltage5v_0
        type: b13
        doc: |
          uint13: ADC Value for the Transceiver Voltage on the 5V bus.
            Value in V = ADC * 0.004

      - id: platform_cmc_rxcrcerrorcount_0
        type: b16
        doc: |
          uint16: Count of received packets with invalid CRC.

      - id: payload_emod_dp_resetcounter_0
        type: b8
        doc: |
          uint8: EMOD Processor Reset Count.
            Note: Value of 255 indicates EMOD is currently powered off and OBC was not able to poll the reset count.

      - id: payload_emod_dp_emodmode_0
        type: b2
        doc: |
          uint2: EMOD Mode.
            0: Idle
            1: Experiment
            3: EMOD is currently powered off and OBC was not able to poll the mode.

      - id: payload_emod_dp_lastpageaddr_0
        type: b24
        doc: |
          uint24: Last address in EMOD memory that data was written to.
            Note: Value of 16777216 (2^24) indicates EMOD is currently powered off and OBC was not able to poll the page address.

      - id: payload_emod_autopollpages_0
        type: b1
        doc: |
          bool: OBC is automatically polling data from EMOD.

      - id: payload_emod_nextpageaddrtopoll_0
        type: b16
        doc: |
          uint16: Next address that the OBC will poll EMOD data from.

      - id: payload_gmod_dp_resetcounter_0
        type: b8
        doc: |
          uint8: GMOD Processor Reset Count.
            Note: Value of 255 indicates EMOD is currently powered off and OBC was not able to poll the reset count.

      - id: payload_gmod_dp_gmodmode_0
        type: b4
        doc: |
          uint4: EMOD Mode.
            1: Idle
            2: Experiment
            3: CPLD Reprogram
            4: SAFE
            5: Experiment 16
            15: GMOD is currently powered off and OBC was not able to poll the mode.

      - id: payload_gmod_dp_lastpagesumaddr_0
        type: b24
        doc: |
          uint24: Last address in GMOD memory that summed channel TTE data was written to.
            Note: Value of 16777216 (2^24) indicates EMOD is currently powered off and OBC was not able to poll the page address.

      - id: payload_gmod_dp_streamsumchstatus_0
        type: b2
        doc: |
          uint2: GMOD is set to automatically send summed channel data to the OBC.
            0: Disabled
            1: Enabled
            3: GMOD is currently powered off and OBC was not able to poll the setting.

      - id: payload_gmod_lastpagesumaddrrx_0
        type: b16
        doc: |
          uint16: Last address in GMOD memory of summed channel TTE data received by the OBC.

      - id: payload_gmod_dp_lastpage16addr_0
        type: b24
        doc: |
          uint24: Last address in GMOD memory that 16 channel TTE data was written to.
            Note: Value of 16777216 (2^24) indicates EMOD is currently powered off and OBC was not able to poll the page address.

      - id: payload_gmod_dp_stream16chstatus_0
        type: b2
        doc: |
          uint2: GMOD is set to automatically send 16 channel data to the OBC.
            0: Disabled
            1: Enabled
            3: GMOD is currently powered off and OBC was not able to poll the setting.

      - id: payload_gmod_lastpage16addrrx_0
        type: b16
        doc: |
          uint16: Last address in GMOD memory of 16 channel TTE data received by the OBC.

      - id: payload_gmod_dp_biasvoltage_0
        type: b16
        doc: |
          uint16: ADC Value for the GMOD Bias PSU Voltage.

      - id: payload_gmod_dp_biasoffsetvalue_0
        type: b16
        doc: |
          uint16: DAC Value for the GMOD Bias PSU adjustment circuit.

      - id: payload_gmod_dp_boostconverterenable_0
        type: b2
        doc: |
          uint2: GMOD Bias PSU is set to Enabled.
            0: Disabled
            1: Enabled
            3: GMOD is currently powered off and OBC was not able to poll the setting.

      - id: payload_gmod_dp_biasoffsetvoltage_0
        type: b16
        doc: |
          uint16: ADC Value for the GMOD Bias PSU adjustment input voltage.

      - id: payload_gmod_dp_biasoffsetenable_0
        type: b2
        doc: |
          uint2: DAC which drives the GMOD Bias PSU adjustment is Enabled.
            0: Disabled
            1: Enabled
            3: GMOD is currently powered off and OBC was not able to poll the setting.

      - id: payload_gmod_grbtriggeringenabled_0
        type: b1
        doc: |
          bool: GMOD GRB Trigger Alorithm is running on OBC.
            0: Disabled
            1: Enabled

      - id: payload_gmod_grbtriggercount_0
        type: b16
        doc: |
          uint16: GMOD GRB Trigger Algorithm is running on OBC.
            0: Disabled
            1: Enabled

      - id: payload_wbc_wbcenabled_0
        type: b1
        doc: |
          bool: WBC Algorithm is running on OBC.
            0: Disabled
            1: Enabled

      - id: payload_wbc_controllerexecutioncount_0
        type: b8
        doc: |
          uint8: Execution Count of the WBC Algorithm.

      - id: core_eventdispatcher_eventcount_0
        type: b32
        doc: |
          uint32: Count of Events recorded by OBC.

      - id: core_eventdispatcher_lastevent_0_severity
        type: b2
        doc: |
          uint2: Last Event Severity.

      - id: core_eventdispatcher_lastevent_0_event_id
        type: b14
        doc: |
          uint14: Last Event ID.

      - id: core_eventdispatcher_lastevent_0_event_source_id
        type: b16
        doc: |
          uint16: Last Event Source ID.

      - id: core_eventdispatcher_lastevent_0_info
        type: b32
        doc: |
          uint32: Information attached to Last Event.

      - id: datapool_paramvalid_170
        type: b1
        doc: |
          bool: platform_obc_gps_lastvalidstatevec is valid.

      - id: datapool_paramvalid_43
        type: b1
        doc: |
          bool: platform_bat_batterycurrent is valid.

      - id: datapool_paramvalid_44
        type: b1
        doc: |
          bool: platform_bat_batteryvoltage is valid.

      - id: datapool_paramvalid_46
        type: b1
        doc: |
          bool: platform_bat_batterytemperature is valid.

      - id: datapool_paramvalid_42
        type: b1
        doc: |
          bool: platform_bat_batterycurrentdir is valid.

      - id: datapool_paramvalid_56
        type: b1
        doc: |
          bool: platform_bat_packedheaterstatus is valid.

      - id: datapool_paramvalid_73
        type: b1
        doc: |
          bool: platform_eps_actualswitchstatesbitmap is valid.

      - id: datapool_paramvalid_74
        type: b1
        doc: |
          bool: platform_eps_switchovercurrentbitmap is valid.

      - id: datapool_paramvalid_77
        type: b1
        doc: |
          bool: platform_eps_boardtemperature is valid.

      - id: datapool_paramvalid_85
        type: b1
        doc: |
          bool: platform_eps_busvoltages is valid.

      - id: datapool_paramvalid_86
        type: b1
        doc: |
          bool: platform._eps_buscurrents is valid.

      - id: datapool_paramvalid_129
        type: b1
        doc: |
          bool: platform_adcs_arraytemperature is valid.

      - id: datapool_paramvalid_80
        type: b1
        doc: |
          bool: platform_eps_solararraycurrents is valid.

      - id: datapool_paramvalid_84
        type: b1
        doc: |
          bool: platform_eps_solararrayvoltages is valid.

      - id: datapool_paramvalid_130
        type: b1
        doc: |
          bool: platform_adcs_packedadcsmode is valid.

      - id: datapool_paramvalid_131
        type: b1
        doc: |
          bool: platform_adcs_executioncount is valid.

      - id: datapool_paramvalid_89
        type: b1
        doc: |
          bool: platform_adcs_rawgyrorate is valid.

      - id: datapool_paramvalid_95
        type: b1
        doc: |
          bool: platform_adcs_fss1alphaangle is valid.

      - id: datapool_paramvalid_96
        type: b1
        doc: |
          bool: platform_adcs_fss1betaangle is valid.

      - id: datapool_paramvalid_2
        type: b1
        doc: |
          bool: platform_cmc_mode is valid.

      - id: datapool_paramvalid_3
        type: b1
        doc: |
          bool: platform_cmc_beaconenable is valid.

      - id: datapool_paramvalid_7
        type: b1
        doc: |
          bool: platform_cmc_txtransparent is valid.

      - id: datapool_paramvalid_8
        type: b1
        doc: |
          bool: platform_cmc_txconvenabled is valid.

      - id: datapool_paramvalid_11
        type: b1
        doc: |
          bool: platform_cmc_txpower is valid.

      - id: datapool_paramvalid_20
        type: b1
        doc: |
          bool: platform_cmc_rxlock is valid.

      - id: datapool_paramvalid_22
        type: b1
        doc: |
          bool: platform_cmc_rxrssi is valid.

      - id: datapool_paramvalid_19
        type: b1
        doc: |
          bool: platform_cmc_rxfrequencyoffset is valid.

      - id: datapool_paramvalid_26
        type: b1
        doc: |
          bool: platform_cmc_rxpacketcount is valid.

      - id: datapool_paramvalid_32
        type: b1
        doc: |
          bool: platform_cmc_temperaturepa is valid.

      - id: datapool_paramvalid_36
        type: b1
        doc: |
          bool: platform_cmc_current5v is valid.

      - id: datapool_paramvalid_34
        type: b1
        doc: |
          bool: platform_cmc_voltage5v is valid.

      - id: datapool_paramvalid_28
        type: b1
        doc: |
          bool: platform_cmc_rxcrcerrorcount is valid.

      - id: datapool_paramvalid_142
        type: b1
        doc: |
          bool: payload_emod_dp_resetcounter is valid.

      - id: datapool_paramvalid_141
        type: b1
        doc: |
          bool: payload_emod_dp_emodmode is valid.

      - id: datapool_paramvalid_143
        type: b1
        doc: |
          bool: payload_emod_dp_lastpageaddr is valid.

      - id: datapool_paramvalid_139
        type: b1
        doc: |
          bool: payload_emod_autopollpages is valid.

      - id: datapool_paramvalid_140
        type: b1
        doc: |
          bool: payload_emod_nextpageaddrtopoll is valid.

      - id: datapool_paramvalid_149
        type: b1
        doc: |
          bool: payload_gmod_dp_resetcounter is valid.

      - id: datapool_paramvalid_148
        type: b1
        doc: |
          bool: payload_gmod_dp_gmodmode is valid.

      - id: datapool_paramvalid_150
        type: b1
        doc: |
          bool: payload_gmod_dp_lastpagesumaddr is valid.

      - id: datapool_paramvalid_151
        type: b1
        doc: |
          bool: payload_gmod_dp_streamsumchstatus is valid.

      - id: datapool_paramvalid_144
        type: b1
        doc: |
          bool: payload_gmod_lastpagesumaddrrx is valid.

      - id: datapool_paramvalid_152
        type: b1
        doc: |
          bool: payload_gmod_dp_lastpage16addr is valid.

      - id: datapool_paramvalid_153
        type: b1
        doc: |
          bool: payload_gmod_dp_stream16chstatus is valid.

      - id: datapool_paramvalid_145
        type: b1
        doc: |
          bool: payload_gmod_lastpage16addrrx is valid.

      - id: datapool_paramvalid_154
        type: b1
        doc: |
          bool: payload_gmod_dp_biasvoltage is valid.

      - id: datapool_paramvalid_155
        type: b1
        doc: |
          bool: payload_gmod_dp_biasoffsetvalue is valid.

      - id: datapool_paramvalid_156
        type: b1
        doc: |
          bool: payload_gmod_dp_boostconverterenable is valid.

      - id: datapool_paramvalid_157
        type: b1
        doc: |
          bool: payload_gmod_dp_biasoffsetvoltage is valid.

      - id: datapool_paramvalid_158
        type: b1
        doc: |
          bool: payload_gmod_dp_biasoffsetenable is valid.

      - id: datapool_paramvalid_146
        type: b1
        doc: |
          bool: payload_gmod_grbtriggeringenabled is valid.

      - id: datapool_paramvalid_147
        type: b1
        doc: |
          bool: payload_gmod_grbtriggercount is valid.

      - id: datapool_paramvalid_168
        type: b1
        doc: |
          bool: payload_wbc_wbcenabled is valid.

      - id: datapool_paramvalid_169
        type: b1
        doc: |
          bool: payload_wbc_controllerexecutioncount is valid.
