From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 40/50] IB/hfi1: add sysfs routines and documentation
Date: Thu, 30 Jul 2015 15:51:50 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507301541170.6551@east.gentwo.org>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com> <20150730192109.25256.56498.stgit@phlsvslse11.ph.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730192109.25256.56498.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 30 Jul 2015, Mike Marciniszyn wrote:

> +HFI1
> +
> +  The hfi1 driver also creates these additional files:
> +
> +   hw_rev - hardware revision
> +   board_id - manufacturing board id
> +   version - driver version
> +   tempsense - thermal sense information
> +   serial - board serial number
> +   nfreectxts - number of free user contexts
> +   nctxts - number of allowed contexts (PSM2)
> +   localbus_info - PCIe info
> +   chip_reset - diagnostic (root only)
> +   boardversion - board version

Arent these already provide by the pci-e driver framework? Tools will not
work if you do not put the information out there in a way that they can be
scanned.

F.e the following output of lspci -vv shows a revision and the board_id
is also usually avaialble. The kernel driver version is also there via
the driver/module directory etc etc. Please integrate properly into the
kernel device driver infrastructure and do not create useless new entries.

lspci -vv

00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-LM (rev 04)
        Subsystem: Fujitsu Technology Solutions Device 11ed
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 28
        Region 0: Memory at f7c00000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at f7c3d000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at f080 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00378  Data: 0000
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e

ls -l /sys/devices/pci0000\:00/0000:00:19.0/driver/module/
total 0
-r--r--r-- 1 root root 4096 Jul 30 14:59 coresize
drwxr-xr-x 2 root root    0 Jul 30 15:47 drivers
drwxr-xr-x 2 root root    0 Jul 30 14:59 holders
-r--r--r-- 1 root root 4096 Jul 30 15:47 initsize
-r--r--r-- 1 root root 4096 Jul 30 14:59 initstate
drwxr-xr-x 2 root root    0 Jul 30 15:47 notes
drwxr-xr-x 2 root root    0 Jul 30 15:47 parameters
-r--r--r-- 1 root root 4096 Jul 30 14:59 refcnt
drwxr-xr-x 2 root root    0 Jul 30 15:47 sections
-r--r--r-- 1 root root 4096 Jul 30 15:47 srcversion
-r--r--r-- 1 root root 4096 Jul 30 15:47 taint
--w------- 1 root root 4096 Jul 30 14:59 uevent
-r--r--r-- 1 root root 4096 Jul 30 15:49 version


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
