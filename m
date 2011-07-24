From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch v2 00/37] add rxe (soft RoCE)
Date: Sun, 24 Jul 2011 14:43:00 -0500
Message-ID: <20110724194300.421253331@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes in v2 include:

	- Updated to Roland's tree as of 7/24/2011

	- Moved the crc32 algorithm into a patch (slice-by-8-for_crc32.c.diff)
	  that goes into the mainline kernel. It has been submitted upstream
	  but is also included in here since it is required to build the driver.

	- renamed rxe_sb8.c rxe_icrc.c since that is all it now does.

	- Cleaned up warnings from checkpatch, C=2 and __CHECK_ENDIAN__.

	- moved small .h files into rxe_loc.h

	- rewrote the Kconfig text to be a little friendlier

	- Changed the patch names to make them easier to handle.

	- the quilt patch series is online at:
	  http://support.systemfabricworks.com/downloads/rxe/patches-v2.tgz

	- librxe is online at:
	  http://support.systemfabricworks.com/downloads/rxe/librxe-1.0.0.tar.gz

	Thanks to Roland Dreier, Bart van Assche and David Dillow for helpful
	suggestions.

Introduction:

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


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
