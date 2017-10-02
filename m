From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: question about mlx5 MSI-X assignment
Date: Mon, 2 Oct 2017 15:10:22 -0400
Message-ID: <78728626-4430-4C57-A0ED-79777416963C@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have a two-socket x86_64 system with two NUMA domains. There is a Mellanox CX-3 Pro
and a CX-4 in this system. The CX-3 Pro is affined to socket 0 / domain 0, and the
CX-4 is affined to socket 1 / domain 1 (since that's where the x16 slot is).

(This is a Supermicro X10DRi mainboard)

The CX-3 Pro compvecs allow interrupts only on the same CPUs as the device's reported
numa_node. I confirmed this by adding logic to the RPC-over-RDMA client to rotate the
ib_alloc_cq's compvec argument, and then I watch /proc/interrupts to see where the
interrupts are delivered. I see interrupts only on cores on socket 0. This matches the
value in the ib_device's numa_node field.

The CX-4 compvecs appear to be spread across both sockets, ie they are not limited to
the device's reported numa_node. /proc/interrupts shows that interrupts can be delivered
on any CPU core on the system. The ib_device's numa_node field contains 1 for this device,
which matches the NUMA domain where this device is bound, but the interrupts appear on
domain 0 or domain 1 (depending on the ib_alloc_cq call's compvec argument).

Is the mlx5 driver correct to allow cross-socket interrupts? Or is the BIOS or platform
somehow binding the CX-4's interrupts incorrectly? Or, do I grossly misunderstand
something?

RPC-over-RDMA in v4.14 always uses a compvec of 0. Due to the above observed behavior,
this means that interrupts for both of these cards always route to socket 0, even though
the CX-4 is affined to socket 1.

ULPs control the compvec, which is an abstraction of the MSI-X. I believe ULPs thus
depend on the lower layers to ensure that device interrupts (and completions) will be
delivered to an appropriate CPU core. That does not appear to be happening with my
CX-4 device.

I'm also considering changing RPC-over-RDMA to allocate its Send and Receive buffers
on the NUMA domain listed in the ib_device's numa_node field. This of course would be
a meaningless change if device interrupts are delivered to some other NUMA domain.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
