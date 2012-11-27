From: Zhangxiaofeng <victor.zhangxiaofeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: mellanox mlx4_core and SR-IOV
Date: Tue, 27 Nov 2012 01:05:57 +0000
Message-ID: <AE94C31276ACE14591CDCF7F6B4E699455547DBF@SZXEML540-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,
I tried to use SR-IOV virtualization for Mellanox ConnectX2 card with kernel 3.6.7.
I met some problem as below:
lspci -v shows:
04:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)
        Subsystem: Mellanox Technologies Device 0036
        Flags: bus master, fast devsel, latency 0, IRQ 32
        Memory at fbd00000 (64-bit, non-prefetchable) [size=1M]
        Memory at f3800000 (64-bit, prefetchable) [size=8M]
        Capabilities: [40] Power Management version 3
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=128 Masked-
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [100] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [148] Device Serial Number 00-02-c9-03-00-4e-4d-2a
        Capabilities: [108] Single Root I/O Virtualization (SR-IOV)
        Kernel driver in use: mlx4_core
        Kernel modules: mlx4_core
Mlx4_core driver complains as below:
mlx4_core: Mellanox ConnectX core driver v1.1 (Dec, 2011)
mlx4_core: Initializing 0000:04:00.0
mlx4_core 0000:04:00.0: Enabling sriov with:4 vfs
mlx4_core 0000:04:00.0: not enough MMIO resources for SR-IOV
mlx4_core 0000:04:00.0: Failed to enable sriov,continuing without sriov enabled
(err = -12).
mlx4_core 0000:04:00.0: irq 100 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 101 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 102 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 103 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 104 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 105 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 106 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 107 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 108 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 109 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 110 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 111 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 112 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 113 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 114 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 115 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 116 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 117 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 118 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 119 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 120 for MSI/MSI-X
mlx4_core 0000:04:00.0: irq 121 for MSI/MSI-X
mlx4_core 0000:04:00.0: command 0xc failed: fw status = 0x40
mlx4_core 0000:04:00.0: command 0xc failed: fw status = 0x40
mlx4_en: Mellanox ConnectX HCA Ethernet driver v2.0 (Dec 2011)
<mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0 (April
4, 2008)
NET: Registered protocol family 10
IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
ib0: multicast join failed for ff12:401b:ffff:0000:0000:0000:ffff:ffff, status -
22
ib0: multicast join failed for ff12:401b:ffff:0000:0000:0000:ffff:ffff, status -
22
ib0: multicast join failed for ff12:401b:ffff:0000:0000:0000:ffff:ffff, status -
22
ib0: enabling connected mode will cause multicast packet drops
ib0: mtu > 4092 will cause multicast packet drops.
ib1: enabling connected mode will cause multicast packet drops
ib1: mtu > 4092 will cause multicast packet drops.

Victor
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
