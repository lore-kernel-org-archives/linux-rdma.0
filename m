From: Wei Lin Guay <weilin-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: SR-IOV support in MLX CX2
Date: Mon, 10 Jan 2011 15:03:00 +0100
Message-ID: <1b60a08628454ebff84d72a1f748b9f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

Is Mellanox CX2 HCA supports SR-IOV? I'm currently using CentOS 5.5 with
Xen 4.0.1 but open for any recommendation on different linux dist. The
first blocking issue that I have is my CX2 doesn't have the SR-IOV
extended capability in the PCI config dump as mentioned in the
specification. What are the additional firmware/driver that is required in
order to have the SR-IOV support in CX2? If SR-IOV is currently not
supported, how can I enable PCI-bypass for CX2 in Xen?

02:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0
5GT/s - IB QDR / 10GigE] (rev b0)
        Subsystem: Mellanox Technologies Device 0017
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fbd00000 (64-bit, non-prefetchable) [size=1M]
        Memory at f9800000 (64-bit, prefetchable) [size=8M]
        Capabilities: [40] Power Management version 3
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=256 Masked-
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [100] Alternative Routing-ID Interpretation (ARI)
        Kernel driver in use: mlx4_core
        Kernel modules: mlx4_core

Thanks,
Wei Lin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
