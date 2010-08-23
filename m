From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC] ipoib: good references make good neighbors
Date: Mon, 23 Aug 2010 15:53:16 -0400
Message-ID: <20100823195316.GL26773@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

We're having a problem where a kernel tree based on 2.6.32 + OFED
1.5.1 is seeing random memory corruption, always in the form of zeros
where good data is supposed to live.

CONFIG_PAGE_DEBUG_ALLOC showed a use after free here:

RIP: 0010:[<ffffffffa02b0bf0>]  [<ffffffffa02b0bf0>] ipoib_neigh_free+0x16/0x59 [ib_ipoib]
Call Trace:
 [<ffffffffa02b4c9a>] ipoib_mcast_free+0x7a/0xfe [ib_ipoib]
 [<ffffffffa02b60bb>] ipoib_mcast_restart_task+0x388/0x419 [ib_ipoib]
 [<ffffffff810425b7>] ? need_resched+0x23/0x2d
 [<ffffffffa02b5d33>] ? ipoib_mcast_restart_task+0x0/0x419 [ib_ipoib]
 [<ffffffff81071765>] worker_thread+0x149/0x1e5
 [<ffffffff81075a0f>] ? autoremove_wake_function+0x0/0x3d
 [<ffffffff8107161c>] ? worker_thread+0x0/0x1e5
 [<ffffffff810757bb>] kthread+0x6e/0x76
 [<ffffffff81012daa>] child_rip+0xa/0x20
 [<ffffffff8107574d>] ? kthread+0x0/0x76
 [<ffffffff81012da0>] ? child_rip+0x0/0x20

The crashes usually pop up while rebooting (which rmmods ipoib), but we
were able to hit it consistently by reseting IB switches, or flipping
ports on and off.

Tina Yang noticed that when ipoib_neigh_alloc() takes a pointer to the
neighbour struct, it doesn't take any references.  I cooked up the patch
below and haven't been able to trigger our corruption since.

Signed-off-by: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--- ofa_kernel-1.5.1/drivers/infiniband/ulp/ipoib/ipoib_main.c	2010-08-23 05:16:57.000000000 -0700
+++ ofa_kernel-1.5.1-refs/drivers/infiniband/ulp/ipoib/ipoib_main.c	2010-08-22 13:35:43.000000000 -0700
@@ -919,6 +919,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(st
 	if (!neigh)
 		return NULL;
 
+	neigh_hold(neighbour);
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
 	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
@@ -932,6 +933,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(st
 void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh)
 {
 	struct sk_buff *skb;
+	struct neighbour *neighbour = neigh->neighbour;
 	*to_ipoib_neigh(neigh->neighbour) = NULL;
 	while ((skb = __skb_dequeue(&neigh->queue))) {
 		++dev->stats.tx_dropped;
@@ -940,6 +942,7 @@ void ipoib_neigh_free(struct net_device 
 	if (ipoib_cm_get(neigh))
 		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
 	kfree(neigh);
+	neigh_release(neighbour);
 }
 
 static int ipoib_neigh_setup_dev(struct net_device *dev, struct neigh_parms *parms)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
