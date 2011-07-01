From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 00/44] RDMA over Ethernet
Date: Fri, 01 Jul 2011 08:18:21 -0500
Message-ID: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set implements a software emulation of RoCE or InfiniBand transport.
It consists of two kernel modules. The first, ib_rxe, implements the RDMA
transport and registers with the RDMA core as a kernel verbs provider. The
second, ib_rxe_net or ib_sample, implement the packet IO layer. ib_rxe_net
attaches to the Linux netdev stack as a network protocol and can send and
receive packets over any Ethernet device. It uses the RoCE protocol to handle
RDMA transport. ib_sample is a pure loopback device that uses the InfiniBand
transport i.e. it includes the LRH header while RoCE only includes the GRH
header.

The modules are configured by entries in /sys. There is a configuration script
(rxe_cfg) that simplifies the use of this interface. Rxe_cfg is part of the
rxe user space code, librxe.

The use of rxe verbs in user space requires the inclusion of librxe as a device
specific plug-in to libibverbs. Librxe is packaged separately.

Copies of the user space library and tools for 'upstream' and a tar file of
these patches are available at support.systemfabricworks.com/downloads/rxe.
-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
