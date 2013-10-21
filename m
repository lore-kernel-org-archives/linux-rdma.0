From: Lukas Hejtmanek <xhejtman-8qz54MUs51PtwjQa/ONI9g@public.gmane.org>
Subject: Re: [Xen-devel] BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 16:06:07 +0200
Message-ID: <20131021140607.GQ20913@ics.muni.cz>
References: <20131021115740.GN20913@ics.muni.cz>
 <52652534.2040303@oracle.com>
 <526545E002000078000FC5F1@nat28.tlf.novell.com>
 <52652E95.3020305@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52652E95.3020305-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: konrad wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 21, 2013 at 09:39:33AM -0400, konrad wilk wrote:
> Anyhow, one easy thing to figure out is to get the lspci -v output
> from the InfiniBand card
> to see where its BARs are, and also the start of the kernel. You
> should see an E820 map (please also boot with
> "debug" on the Linux command line).

note, adding _PAGE_IO as Jan suggested fixed those mem errors.

here is lspci from the card and its virtual functions.

06:00.0 Network controller: Mellanox Technologies MT27500 Family [Conne=
ctX-3]
        Subsystem: Mellanox Technologies Device 0017
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at dfa00000 (64-bit, non-prefetchable) [size=3D=
1M]
        Region 2: Memory at 380fff000000 (64-bit, prefetchable) [size=3D=
8M]
        Expansion ROM at df900000 [disabled] [size=3D1M]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1=
-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 P=
ME-
        Capabilities: [48] Vital Product Data
                Product Name: CX353A - ConnectX-3 QSFP
                Read-only fields:
                        [PN] Part number: MCX353A-QCBT        =20
                        [EC] Engineering changes: A4
                        [SN] Serial number: MT1327X00814           =20
                        [V0] Vendor specific: PCIe Gen3 x8   =20
                        [RV] Reserved: checksum good, 0 byte(s) reserve=
d
                Read/write fields:
                        [V1] Vendor specific: N/A  =20
                        [YA] Asset tag: N/A                    =20
                        [RW] Read-write area: 105 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 253 byte(s) free
                        [RW] Read-write area: 252 byte(s) free
                End
        Capabilities: [9c] MSI-X: Enable+ Count=3D128 Masked-
                Vector table: BAR=3D0 offset=3D0007c000
                PBA: BAR=3D0 offset=3D0007d000
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s =
<64ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- U=
nsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FL=
Reset-
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr=
- TransPend-
                LnkCap: Port #8, Speed 8GT/s, Width x8, ASPM L0s, Laten=
cy L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- =
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ D=
LActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- Spe=
edDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, Enter=
ModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationC=
omplete+, EqualizationPhase1+
                         EqualizationPhase2+, EqualizationPhase3-, Link=
EqualizationRequest-
        Capabilities: [100 v1] Alternative Routing-ID Interpretation (A=
RI)
                ARICap: MFVC- ACS-, Next Function: 0
                ARICtl: MFVC- ACS-, Function Group: 0
        Capabilities: [148 v1] Device Serial Number 00-02-c9-03-00-b6-f=
c-70
        Capabilities: [108 v1] Single Root I/O Virtualization (SR-IOV)
                IOVCap: Migration-, Interrupt Message Number: 000
                IOVCtl: Enable+ Migration- Interrupt- MSE+ ARIHierarchy=
+
                IOVSta: Migration-
                Initial VFs: 64, Total VFs: 64, Number of VFs: 4, Funct=
ion Dependency Link: 00
                VF offset: 1, stride: 1, Device ID: 1004
                Supported Page Size: 000007ff, System Page Size: 000000=
01
                Region 2: Memory at 0000380fdf000000 (64-bit, prefetcha=
ble)
                VF Migration: offset: 00000000, BIR: 0
        Capabilities: [154 v2] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmp=
lt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmp=
lt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmp=
lt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonF=
atalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonF=
atalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap=
+ ChkEn-
        Capabilities: [18c v1] #19
        Kernel driver in use: mlx4_core

06:00.1 Network controller: Mellanox Technologies MT27500 Family [Conne=
ctX-3 Virtual Function]
        Subsystem: Mellanox Technologies Device 61b0
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 2: [virtual] Memory at 380fdf000000 (64-bit, prefetchabl=
e) [size=3D8M]
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s =
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- U=
nsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FL=
Reset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr=
- TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM unknown, L=
atency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- =
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-=
 DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- S=
peedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, Enter=
ModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationC=
omplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, Link=
EqualizationRequest-
        Capabilities: [9c] MSI-X: Enable+ Count=3D4 Masked-
                Vector table: BAR=3D2 offset=3D00002000
                PBA: BAR=3D2 offset=3D00003000
        Kernel driver in use: mlx4_core

06:00.2 Network controller: Mellanox Technologies MT27500 Family [Conne=
ctX-3 Virtual Function]
        Subsystem: Mellanox Technologies Device 61b0
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 2: [virtual] Memory at 380fdf800000 (64-bit, prefetchabl=
e) [size=3D8M]
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s =
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- U=
nsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FL=
Reset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr=
- TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM unknown, L=
atency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- =
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-=
 DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- S=
peedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, Enter=
ModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationC=
omplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, Link=
EqualizationRequest-
        Capabilities: [9c] MSI-X: Enable+ Count=3D4 Masked-
                Vector table: BAR=3D2 offset=3D00002000
                PBA: BAR=3D2 offset=3D00003000
        Kernel driver in use: mlx4_core

06:00.3 Network controller: Mellanox Technologies MT27500 Family [Conne=
ctX-3 Virtual Function]
        Subsystem: Mellanox Technologies Device 61b0
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 2: [virtual] Memory at 380fe0000000 (64-bit, prefetchabl=
e) [size=3D8M]
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s =
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- U=
nsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FL=
Reset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr=
- TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM unknown, L=
atency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- =
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-=
 DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- S=
peedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, Enter=
ModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationC=
omplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, Link=
EqualizationRequest-
        Capabilities: [9c] MSI-X: Enable+ Count=3D4 Masked-
                Vector table: BAR=3D2 offset=3D00002000
                PBA: BAR=3D2 offset=3D00003000
        Kernel driver in use: mlx4_core

06:00.4 Network controller: Mellanox Technologies MT27500 Family [Conne=
ctX-3 Virtual Function]
        Subsystem: Mellanox Technologies Device 61b0
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- Par=
Err- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 2: [virtual] Memory at 380fe0800000 (64-bit, prefetchabl=
e) [size=3D8M]
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s =
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- U=
nsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FL=
Reset-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr=
- TransPend-
                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM unknown, L=
atency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- =
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-=
 DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- S=
peedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range, Enter=
ModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB, EqualizationC=
omplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-, Link=
EqualizationRequest-
        Capabilities: [9c] MSI-X: Enable+ Count=3D4 Masked-
                Vector table: BAR=3D2 offset=3D00002000
                PBA: BAR=3D2 offset=3D00003000
        Kernel driver in use: mlx4_core

and this is from dmesg:

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x0000000000090fff] usable
[    0.000000] Xen: [mem 0x0000000000091800-0x00000000000fffff] reserve=
d
[    0.000000] Xen: [mem 0x0000000000100000-0x000000007dd76fff] usable
[    0.000000] Xen: [mem 0x000000007dd77000-0x000000007ddb5fff] reserve=
d
[    0.000000] Xen: [mem 0x000000007ddb6000-0x000000007debefff] ACPI da=
ta
[    0.000000] Xen: [mem 0x000000007debf000-0x000000007e0dafff] ACPI NV=
S
[    0.000000] Xen: [mem 0x000000007e0db000-0x000000007f357fff] reserve=
d
[    0.000000] Xen: [mem 0x000000007f358000-0x000000007f7fffff] ACPI NV=
S
[    0.000000] Xen: [mem 0x0000000080000000-0x000000008fffffff] reserve=
d
[    0.000000] Xen: [mem 0x00000000fec00000-0x00000000fec01fff] reserve=
d
[    0.000000] Xen: [mem 0x00000000fec40000-0x00000000fec40fff] reserve=
d
[    0.000000] Xen: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserve=
d
[    0.000000] Xen: [mem 0x00000000fee00000-0x00000000fee00fff] reserve=
d
[    0.000000] Xen: [mem 0x00000000ff000000-0x00000000ffffffff] reserve=
d
[    0.000000] Xen: [mem 0x0000000100000000-0x000000107fffffff] usable

[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> =
reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x1080000 max_arch_pfn =3D 0x40000000=
0
[    0.000000] e820: last_pfn =3D 0x7dd77 max_arch_pfn =3D 0x400000000
[    0.000000] e820: [mem 0x90000000-0xfebfffff] available for PCI devi=
ces
[   23.917733] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in=
 E820
[   24.587366] e820: reserve RAM buffer [mem 0x00091000-0x0009ffff]
[   24.587468] e820: reserve RAM buffer [mem 0x7dd77000-0x7fffffff]

do you need anything else?

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
