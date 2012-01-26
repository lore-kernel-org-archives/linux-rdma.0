From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2] IB/{mlx4,ipoib}: bug fixes for vendor mads and
 ipoib/gro
Date: Thu, 26 Jan 2012 16:39:11 +0200
Message-ID: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This short series fixes two kind of badly hurting bugs that we
stepped on lately. We would be happy to have them treated quickly
so they can be pushed further to -stable, distros, etc.

The 1st bug is in the mlx4_ib driver where vendor mads are just silently
dropped, which means that vendor specific features such as FDR10 can't be
queried and configured - with the fix being to let the firmware handle them...

The 2nd bug relates to GRO with IPoIB, it turns out that the GRO stack assumes
an Ethernet Link layer (MAC) header to be present for all packets, and
without passing an L2 similarity check, no GRO merging will be done - the
fix is to let that check pass successfully by pointing the skb mac header
to an area within the GRH headroom location in the packet buffer.

Or.

Jack Morgenstein (1):
  IB/mlx4: pass SMP vendor-specific attribute MADs to firmware

Shlomo Pongratz (1):
  IB/ipoib: fix GRO merge failure for IPoIB originated TCP streams

 drivers/infiniband/hw/mlx4/mad.c        |    7 ++-----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 7 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
