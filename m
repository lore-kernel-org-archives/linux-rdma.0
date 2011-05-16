From: Hiroyuki Sato <hiroysato@gmail.com>
Subject: [Q] Mellanox ConnectX QDR on SandyBridge motherboard works only PCIex
 GEN1 speed.
Date: Mon, 16 May 2011 21:57:59 +0900
Message-ID: <BANLkTikJ2xtdWXxV3PkVn04iNUz21UZqQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma <linux-rdma@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Dears developers.

We are now investigating Mellanox ConnectX QDR on SandyBridge
motherboard(P67/H67/C206),
and have a serious performance problem on this configuration.

Any information is appreciated.

* Questions

  (1) kerenel parameters.

    What parameter should I change to detect ConnectX GEN2 speed??
with vanilla kernel??

    It is mean that, enable CONFIG_XXXX parameters, or change module
parameters, apply patch .. and so on

  (2) What kernel function should I check to work ConnectX with PCIex
GEN2 speed?? on C206 chipset.

    check kernel output, execute some commands, add printk in functions....

* Problem

  (1) ConnectX works only PCI express GEN1 speed (2.5GT/s) on
CentOS5.5 and Ubuntu 10.10 on P67/H67 chipset.

    This is lspci output. (complete output attached below)

         LnkSta:     Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-

    But, Scientific Linux6, and Ubuntu 10.10 works GEN2(5.0GT/s) speed
on same motherboard.

    And I tried to build vanilla kernel on Ubuntu 10.04 with default
configuration.
    The kerenel newer than Ubuntu 10.10, but It still works only GEN1 speeed.


  (2) ConnectX works only PCI express GEN1 speed on Scientific Linux6,
CentOS 5.5 Ubuntu 10.10 and 10.04


* Environment (one of example)

  - OFED 1.5.3.1
  - Ubuntu 10.4 x64 server, and CentOS 5.5
  - ASUS P8P67-WS-Revolution
  - 1-port ConnectX QDR : Mellanox Technologies MT26428 [ConnectX VPI
PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)


* lspci output

  04:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe
2.0 5GT/s - IB QDR / 10GigE] (rev b0)
      Subsystem: Mellanox Technologies Device 0022
      Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
      Latency: 0, Cache Line Size: 64 bytes
      Interrupt: pin A routed to IRQ 18
      Region 0: Memory at fe100000 (64-bit, non-prefetchable) [size=1M]
      Region 2: Memory at d0000000 (64-bit, prefetchable) [size=8M]
      Capabilities: [40] Power Management version 3
           Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
           Status: D0 PME-Enable- DSel=0 DScale=0 PME-
      Capabilities: [48] Vital Product Data <?>
      Capabilities: [9c] MSI-X: Enable+ Mask- TabSize=256
           Vector table: BAR=0 offset=0007c000
           PBA: BAR=0 offset=0007d000
      Capabilities: [60] Express (v2) Endpoint, MSI 00
           DevCap:     MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<64ns, L1 unlimited
                ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
           DevCtl:     Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                MaxPayload 128 bytes, MaxReadReq 512 bytes
           DevSta:     CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
           LnkCap:     Port #8, Speed 5GT/s, Width x8, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                ClockPM- Suprise- LLActRep- BwNot-
           LnkCtl:     ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
           LnkSta:     Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
      Capabilities: [100] #0e
      Kernel driver in use: mlx4_core
      Kernel modules: mlx4_en, mlx4_core
  00: b3 15 3c 67 06 04 10 00 b0 00 06 0c 10 00 00 00
  10: 04 00 10 fe 00 00 00 00 0c 00 00 d0 00 00 00 00
  20: 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 22 00
  30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 00 00
  40: 01 48 03 00 00 00 00 00 03 9c ff 7f 11 11 00 00
  50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  60: 10 00 02 00 01 8e 00 00 00 20 00 00 82 f4 03 08
  70: 00 00 81 00 00 00 00 00 00 00 00 00 00 00 00 00
  80: 00 00 00 00 1f 00 00 00 00 00 00 00 00 00 00 00
  90: 02 00 00 00 00 00 00 00 00 00 00 00 11 60 ff 80
  a0: 00 c0 07 00 00 d0 07 00 05 00 8a 00 00 00 00 00
  b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Sincerely

--
Hiroyuki Sato.
