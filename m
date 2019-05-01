From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
Date: Tue, 30 Apr 2019 20:00:40 -0700
Message-ID: <CALzJLG-TgHP8tgv_1eqYmWjpO4nRD3=7QRdyGXGp1x_qQdKErg@mail.gmail.com>
References: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw>
Sender: netdev-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: kliteyn@mellanox.com, ozsh@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 30, 2019 at 6:23 PM Qian Cai <cai@lca.pw> wrote:
>
> Reverted the commit b169e64a2444 ("net/mlx5: Geneve, Add flow table capabilities
> for Geneve decap with TLV options") fixed the problem below during boot ends up
> without networking.
>

Hi Qian, thanks for the report, i clearly see where the issue is,
mlx5_ifc_cmd_hca_cap_bits offsets are all off ! due to cited patch,
will fix ASAP.

> [   92.471247] mlx5_core 0000:0b:00.0: mlx5_cmd_check:744:(pid 13):
> CREATE_EQ(0x301) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8fef)
> [   92.484824] mlx5_core 0000:0b:00.0: create_async_eqs:572:(pid 13): failed to
> create async EQ -22
> [   92.603279] mlx5_core 0000:0b:00.0: mlx5_eq_table_create:1007:(pid 13):
> Failed to create async EQs
> [   92.630541] mlx5_core 0000:0b:00.0: mlx5_load:1053:(pid 13): Failed to create EQs
> [   94.866908] mlx5_core 0000:0b:00.0: init_one:1329:(pid 13): mlx5_load_one
> failed with error code -22
> [   94.879657] mlx5_core: probe of 0000:0b:00.0 failed with error -22
> [   94.887784] mlx5_core 0000:0b:00.1: Adding to iommu group 2
> [   95.017012] mlx5_core 0000:0b:00.1: firmware version: 14.21.1000
> [   95.023090] mlx5_core 0000:0b:00.1: 63.008 Gb/s available PCIe bandwidth (8
> GT/s x8 link)
> [   96.155792] mlx5_core 0000:0b:00.1: mlx5_cmd_check:744:(pid 13):
> CREATE_EQ(0x301) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8fef)
> [   96.169220] mlx5_core 0000:0b:00.1: create_async_eqs:572:(pid 13): failed to
> create async EQ -22
> [   96.199340] mlx5_core 0000:0b:00.1: mlx5_eq_table_create:1007:(pid 13):
> Failed to create async EQs
> [   96.224004] mlx5_core 0000:0b:00.1: mlx5_load:1053:(pid 13): Failed to create EQs
> [   97.681695] mlx5_core 0000:0b:00.1: init_one:1329:(pid 13): mlx5_load_one
> failed with error code -22
> [   97.692749] mlx5_core: probe of 0000:0b:00.1 failed with error -22
>
> # lspci -vvv
> ...
> 0b:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
>         Subsystem: Hewlett Packard Enterprise Device 028a
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 23
>         NUMA node: 0
>         Region 0: Memory at 10000000000 (64-bit, prefetchable) [size=32M]
>         Expansion ROM at 43000000 [disabled] [size=1M]
>         Capabilities: [60] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
>                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM not supported
>                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
>                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
>                          AtomicOpsCtl: ReqEn-
>                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                          Compliance De-emphasis: -6dB
>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+,
> EqualizationPhase1+
>                          EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
>         Capabilities: [48] Vital Product Data
>                 End
>         Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
>                 Vector table: BAR=0 offset=00002000
>                 PBA: BAR=0 offset=00003000
>         Capabilities: [c0] Vendor Specific Information: Len=18 <?>
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
> ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 AERCap: First Error Pointer: 04, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
>                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
>                 HeaderLog: 00000000 00000000 00000000 00000000
>         Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
>                 ARICap: MFVC- ACS-, Next Function: 1
>                 ARICtl: MFVC- ACS-, Function Group: 0
>         Capabilities: [180 v1] Single Root I/O Virtualization (SR-IOV)
>                 IOVCap: Migration-, Interrupt Message Number: 000
>                 IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy+
>                 IOVSta: Migration-
>                 Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
>                 VF offset: 2, stride: 1, Device ID: 1016
>                 Supported Page Size: 000007ff, System Page Size: 00000001
>                 Region 0: Memory at 0000010004800000 (64-bit, prefetchable)
>                 VF Migration: offset: 00000000, BIR: 0
>         Capabilities: [1c0 v1] #19
>         Capabilities: [230 v1] Access Control Services
>                 ACSCap: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
> DirectTrans-
>                 ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
> DirectTrans-
>         Kernel driver in use: mlx5_core
>         Kernel modules: mlx5_core
>
> 0b:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
>         Subsystem: Hewlett Packard Enterprise Device 028a
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 24
>         NUMA node: 0
>         Region 0: Memory at 10002000000 (64-bit, prefetchable) [size=32M]
>         Expansion ROM at 43100000 [disabled] [size=1M]
>         Capabilities: [60] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLimit 0.000W
>                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM not supported
>                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
>                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
>                          AtomicOpsCtl: ReqEn-
>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
> EqualizationPhase1-
>                          EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>         Capabilities: [48] Vital Product Data
>                 End
>         Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
>                 Vector table: BAR=0 offset=00002000
>                 PBA: BAR=0 offset=00003000
>         Capabilities: [c0] Vendor Specific Information: Len=18 <?>
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot-,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC-
> UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
> ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
>                 AERCap: First Error Pointer: 04, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
>                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
>                 HeaderLog: 00000000 00000000 00000000 00000000
>         Capabilities: [150 v1] Alternative Routing-ID Interpretation (ARI)
>                 ARICap: MFVC- ACS-, Next Function: 0
>                 ARICtl: MFVC- ACS-, Function Group: 0
>         Capabilities: [180 v1] Single Root I/O Virtualization (SR-IOV)
>                 IOVCap: Migration-, Interrupt Message Number: 000
>                 IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy-
>                 IOVSta: Migration-
>                 Initial VFs: 8, Total VFs: 8, Number of VFs: 0, Function Dependency Link: 00
>                 VF offset: 9, stride: 1, Device ID: 1016
>                 Supported Page Size: 000007ff, System Page Size: 00000001
>                 Region 0: Memory at 0000010004000000 (64-bit, prefetchable)
>                 VF Migration: offset: 00000000, BIR: 0
>         Capabilities: [230 v1] Access Control Services
>                 ACSCap: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
> DirectTrans-
>                 ACSCtl: SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl-
> DirectTrans-
>         Kernel driver in use: mlx5_core
>         Kernel modules: mlx5_core
