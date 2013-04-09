From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 9 Apr 2013 15:51:47 +0400
Message-ID: <CACaajQva3nUe+u3YpHoE4wgiR6-mDoQtnOhR4Cpeu4iwPK0HUQ@mail.gmail.com>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com>
 <5163FEF4.1000507@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5163FEF4.1000507-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2013/4/9 Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>:
> Because 2048 is the default and 4096 is the max. supported MTU by the
> hardware.
>
>> How can i set active mtu?
>
> Something like this:
> echo 4096 > /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu

After doing this all srp connections down and port is down. I need to
restart openibd

06:00.0 Network controller: Mellanox Technologies MT27500 Family [ConnectX-3]
        Subsystem: Mellanox Technologies Device 0017
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 42
        Region 0: Memory at df900000 (64-bit, non-prefetchable) [size=1M]
        Region 2: Memory at de000000 (64-bit, prefetchable) [size=8M]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
                Not readable
        Capabilities: [9c] MSI-X: Enable+ Count=128 Masked-
                Vector table: BAR=0 offset=0007c000
                PBA: BAR=0 offset=0007d000
        Capabilities: [60] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<64ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop- FLReset-
                        MaxPayload 256 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #8, Speed 8GT/s, Width x8, ASPM L0s,
Latency L0 unlimited, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete-, EqualizationPhase1-
                         EqualizationPhase2-, EqualizationPhase3-,
LinkEqualizationRequest-
        Capabilities: [100 v1] Alternative Routing-ID Interpretation (ARI)
                ARICap: MFVC- ACS-, Next Function: 0
                ARICtl: MFVC- ACS-, Function Group: 0
        Capabilities: [148 v1] Device Serial Number 00-25-90-ff-ff-17-9b-24
        Capabilities: [18c v1] #19
        Kernel driver in use: mlx4_core
        Kernel modules: mlx4_core


> Could be a bug. Which OFED/Kernel (if using in-tree IB modules) do you use?
> Mine says with ConnectX2 QDR: "40 Gb/sec (4X QDR)"

I'm using stock 3.8.6 kernel and xen patches on top. And i'm use
modules provided with kernel. (only ib_srp i'm use from Bart github
repo)


> You should see "40 Gb/sec (4X QDR)" here. Perhaps the OFED is too old so
> that FDR and ConnectX 3 aren't supported, yet. "10 Gb/sec (4X)" seems to
> be the default case if a rate isn't supported.

Yes, in older card with ConnecX i see this, but in case of ConnectX-3 only 10 Gb

--
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
