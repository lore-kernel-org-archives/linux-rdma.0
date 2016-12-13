From: Joshua McBeth <joshua.mcbeth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SR-IOV with mlx4 on ConnectX-2 fails with DMAR errors
Date: Mon, 12 Dec 2016 22:57:58 -0500
Message-ID: <CAN27Ff74Ov8bgsZP1QJJOwvWc5_KOW_U=PsP+=Z87AJz+VSAOw@mail.gmail.com>
References: <CAN27Ff4RYh3y_45PUxxXhGuDvrrrjm8qe38fj5JPq7oV2QmdYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN27Ff4RYh3y_45PUxxXhGuDvrrrjm8qe38fj5JPq7oV2QmdYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Regarding this issue, I discovered earlier kernels were working with
SR-IOV enabled and bisected to the commit
4be90bc60df47f6268b594c4fb6c90f0ff2f519f ("IB/mad: Remove
ib_get_dma_mr calls").

However, this commit seems to be part of a larger refactoring patch
set and reverting just this commit does not resolve the DMAR errors
nor enable the 'ib0' interface to function.

On Mon, Dec 12, 2016 at 11:04 AM, Joshua McBeth <joshua.mcbeth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I am having some issues getting SR-IOV working with a Mellanox
> ConnectX-2 in a Supermicro X8DTH-6F.
>
> The Infiniband adapter has been flashed with the latest compatible
> firmware with SR-IOV enabled and SR-IOV/virtualization is enabled in
> the BIOS and working for other hardware (with 2 gigabit ethernet, 1
> wireless ethernet, 1 nVidia GPU passed through to qemu/kvm guests).
> The Infiniband adapter functions as expected if SR-IOV is not enabled
> in the driver.
>
> When I enable SR-IOV in the mlx4 driver ( mlx4_core.port_type_array=1
> mlx4_core.num_vfs=8 mlx4_core.probe_vf=0 ), the ib0 interface does not
> function.  The link is never reported as up in dmesg or ibstat, but a
> DMAR error is reported around when the link would be expected to come
> up.  Attempts to use ibping result in additional DMAR errors and no
> responses are received by the ibping application.  The DMAR errors are
> reported for a different bus address than the iommu seems to be
> getting configured for so I am thinking this is a driver error.
>
> I have excerpted the issue below.
>
> Here the devices added to the iommu are 0000:05:0x.x - 0000:05:01.0
>
> ------ dmesg excerpts
>
> [   44.410799] mlx4_core 0000:05:00.0: Enabling SR-IOV with 8 VFs
> [   44.512772] pci 0000:05:00.1: [15b3:1002] type 00 class 0x0c0600
> [   44.513052] pci 0000:05:00.1: Max Payload Size set to 256 (was 128, max 256)
> [   44.513520] iommu: Adding device 0000:05:00.1 to group 44
> [   44.513722] mlx4_core: Initializing 0000:05:00.1
> [   44.513891] mlx4_core 0000:05:00.1: enabling device (0000 -> 0002)
> [   44.514081] mlx4_core 0000:05:00.1: Skipping virtual function:1
> [   44.514332] pci 0000:05:00.2: [15b3:1002] type 00 class 0x0c0600
> [   44.514604] pci 0000:05:00.2: Max Payload Size set to 256 (was 128, max 256)
> [   44.515047] iommu: Adding device 0000:05:00.2 to group 45
> [   44.515225] mlx4_core: Initializing 0000:05:00.2
> [   44.515388] mlx4_core 0000:05:00.2: enabling device (0000 -> 0002)
> [   44.515572] mlx4_core 0000:05:00.2: Skipping virtual function:2
> ...
> [   44.523297] pci 0000:05:01.0: [15b3:1002] type 00 class 0x0c0600
> [   44.523570] pci 0000:05:01.0: Max Payload Size set to 256 (was 128, max 256)
> [   44.524007] iommu: Adding device 0000:05:01.0 to group 51
> [   44.524194] mlx4_core: Initializing 0000:05:01.0
> [   44.524363] mlx4_core 0000:05:01.0: enabling device (0000 -> 0002)
> [   44.524554] mlx4_core 0000:05:01.0: Skipping virtual function:8
> [   44.524746] mlx4_core 0000:05:00.0: Running in master mode
> [   46.867330] mlx4_core 0000:05:00.0: PCIe link speed is 5.0GT/s,
> device supports 5.0GT/s
> [   46.867613] mlx4_core 0000:05:00.0: PCIe link width is x8, device supports x8
> [   46.910736] mlx4_core: Initializing 0000:05:00.1
> [   46.910913] mlx4_core 0000:05:00.1: enabling device (0000 -> 0002)
> [   46.911102] mlx4_core 0000:05:00.1: Skipping virtual function:1
> ...
> [   46.915085] mlx4_core: Initializing 0000:05:01.0
> [   46.915257] mlx4_core 0000:05:01.0: enabling device (0000 -> 0002)
> [   46.915440] mlx4_core 0000:05:01.0: Skipping virtual function:8
>
> ---
>
> Interface is brought up here by init scripts and what I assume is the
> link state notification seems to be eaten by iommu
>
> The adapter seems to now have the bus address [0000:]05:06.1?
>
> ---
>
>
> [   71.631199] DMAR: DRHD: handling fault status reg 2
> [   71.631204] DMAR: [DMA Read] Request device [05:06.1] fault addr
> c2652b000 [fault reason 02] Present bit in context entry is clear
> [   72.020267] ib0: enabling connected mode will cause multicast packet drops
> [   72.020307] ib0: mtu > 2044 will cause multicast packet drops.
>
> ------
>
> Here I attempt to ibping another node 3 times and each packet results
> in a DMAR error, again with a different bus address than was added to
> the IOMMU:
>
> ------ dmesg excerpt continues
>
> [  103.134429] DMAR: DRHD: handling fault status reg 102
> [  103.134434] DMAR: [DMA Read] Request device [05:06.1] fault addr
> 81b081000 [fault reason 02] Present bit in context entry is clear
> [  105.135927] DMAR: DRHD: handling fault status reg 202
> [  105.136013] DMAR: [DMA Read] Request device [05:06.1] fault addr
> 81b081000 [fault reason 02] Present bit in context entry is clear
> [  107.137479] DMAR: DRHD: handling fault status reg 302
> [  107.137484] DMAR: [DMA Read] Request device [05:06.1] fault addr
> 81b081000 [fault reason 02] Present bit in context entry is clear
>
> ------ uname -a
>
> Linux cuprum 4.8.1-gentoo #1 SMP Sun Dec 11 00:05:06 UTC 2016 x86_64
> Intel(R) Xeon(R) CPU X5650 @ 2.67GHz GenuineIntel GNU/Linux
>
> ------- lspci excerpt with SR-IOV disabled
>
> 05:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe
> 2.0 5GT/s - IB QDR / 10GigE] (rev b0)
> Subsystem: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s
> - IB QDR / 10GigE]
> Flags: bus master, fast devsel, latency 0, IRQ 49, NUMA node 0
> Memory at fae00000 (64-bit, non-prefetchable) [size=1M]
> Memory at f8800000 (64-bit, prefetchable) [size=8M]
> Capabilities: [40] Power Management version 3
> Capabilities: [48] Vital Product Data
> Capabilities: [9c] MSI-X: Enable+ Count=128 Masked-
> Capabilities: [60] Express Endpoint, MSI 00
> Capabilities: [100] Alternative Routing-ID Interpretation (ARI)
> Capabilities: [148] Device Serial Number 00-02-c9-03-00-07-7d-2e
> Capabilities: [108] Single Root I/O Virtualization (SR-IOV)
> Kernel driver in use: mlx4_core
> Kernel modules: mlx4_core
>
> ------ full dmesg is attached
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
