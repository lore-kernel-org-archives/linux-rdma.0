From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [Patch] Init ipoib_neigh.dgid
Date: Wed, 11 Nov 2009 09:34:51 -0800
Message-ID: <1257960891.14154.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ipoib can miss a change in dgid under some conditions.  The problem is
caused when ipoib_neigh->dgid contains a stale address.  The fix is to
set ipoib_neigh->dgid to zero in ipoib_neigh_alloc().

Detail description: A systems using bonding on its ipoib interface has
switched it active slave interface from interface A to B and back to A
setting up the situation for this bug.  The system that fails will not
correctly processes the 2nd address change.

When an address has changed neighbor->ha is updated with the new address.
Each neighbor has an associated ipoib_neigh.  ipoib_neigh->dgid also
holds a copy of the remote node's hardware address.  When an address
changes neighbor->ha is updated by the network layer (arp code) with the
new address.  Ipoib detects this change in ipoib_start_xmit() by comparing
neighbor->ha with ipoib_neigh->dgid.  The bug is that ipoib_neigh->dgid
already contains the new address(A) thus the change from B to A is missed
by ipoib.  Here is the sequence of events:

ipoib_neigh->dgid = A neighbor->ha=A

The address is switched to B (the first switch)

neighbor->ha=B

The change is seen in ipoib_start_xmit(). neighbor->ha !=
ipoib_neigh->dgid

The ipoib_neigh is released, and a new one is allocated.

The memory allocation system returned the same chunk of memory that was
just released, therefore ipoib_neigh->dgid still contains A at this point.

ipoib_neigh->dgid should be updated in neigh_add_path(), but if the
following conditions are true dgid is not updated.

        1) __path_find() returns a path

        2) path->ah is NULL

The remote system now switches from address B to A, neighbor->ha is
updated to A.

Now we have: ipoib_neigh->dgid = A neighbor->ha=A

Since the address are the same ipoib won't process the change in address.

Signed-off-by: David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

------------------------------------------------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2bf5116..25ef50b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -884,6 +884,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
 
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
+	memset(&neigh->dgid.raw, 0, sizeof(union ib_gid));
 	*to_ipoib_neigh(neighbour) = neigh;
 	skb_queue_head_init(&neigh->queue);
 	ipoib_cm_set(neigh, NULL);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
