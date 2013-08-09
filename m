From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] IPoIB: Fix race in deleting ipoib_neigh entries
Date: Thu,  8 Aug 2013 17:44:22 -0700
Message-ID: <1376009062-3049-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In several places, this snippet is used when removing neigh entries:

	list_del(&neigh->list);
	ipoib_neigh_free(neigh);

The list_del() removes neigh from the associated struct ipoib_path, while
ipoib_neigh_free() removes neigh from the device's neigh entry lookup
table.  Both of these operations are protected by the priv->lock
spinlock.  The table however is also protected via RCU, and so naturally
the lock is not held when doing reads.

This leads to a race condition, in which a thread may successfully look
up a neigh entry that has already been deleted from neigh->list.  Since
the previous deletion will have marked the entry with poison, a second
list_del() on the object will cause a panic:

  #5 [ffff8802338c3c70] general_protection at ffffffff815108c5
     [exception RIP: list_del+16]
     RIP: ffffffff81289020  RSP: ffff8802338c3d20  RFLAGS: 00010082
     RAX: dead000000200200  RBX: ffff880433e60c88  RCX: 0000000000009e6c
     RDX: 0000000000000246  RSI: ffff8806012ca298  RDI: ffff880433e60c88
     RBP: ffff8802338c3d30   R8: ffff8806012ca2e8   R9: 00000000ffffffff
     R10: 0000000000000001  R11: 0000000000000000  R12: ffff8804346b2020
     R13: ffff88032a3e7540  R14: ffff8804346b26e0  R15: 0000000000000246
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
  #6 [ffff8802338c3d38] ipoib_cm_tx_handler at ffffffffa066fe0a [ib_ipoib]
  #7 [ffff8802338c3d98] cm_process_work at ffffffffa05149a7 [ib_cm]
  #8 [ffff8802338c3de8] cm_work_handler at ffffffffa05161aa [ib_cm]
  #9 [ffff8802338c3e38] worker_thread at ffffffff81090e10
 #10 [ffff8802338c3ee8] kthread at ffffffff81096c66
 #11 [ffff8802338c3f48] kernel_thread at ffffffff8100c0ca

We move the list_del() into ipoib_neigh_free(), so that deletion happens
only once, after the entry has been successfully removed from the lookup
table.  This same behavior is already used in ipoib_del_neighs_by_gid()
and __ipoib_reap_neigh().

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |    3 ---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    9 +++------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 3eceb61..7a31754 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -817,7 +817,6 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 
 		if (neigh) {
 			neigh->cm = NULL;
-			list_del(&neigh->list);
 			ipoib_neigh_free(neigh);
 
 			tx->neigh = NULL;
@@ -1234,7 +1233,6 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 
 		if (neigh) {
 			neigh->cm = NULL;
-			list_del(&neigh->list);
 			ipoib_neigh_free(neigh);
 
 			tx->neigh = NULL;
@@ -1325,7 +1323,6 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 			neigh = p->neigh;
 			if (neigh) {
 				neigh->cm = NULL;
-				list_del(&neigh->list);
 				ipoib_neigh_free(neigh);
 			}
 			list_del(&p->list);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index c6f71a8..82cec1a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -493,7 +493,6 @@ static void path_rec_completion(int status,
 									       path,
 									       neigh));
 				if (!ipoib_cm_get(neigh)) {
-					list_del(&neigh->list);
 					ipoib_neigh_free(neigh);
 					continue;
 				}
@@ -618,7 +617,6 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 			if (!ipoib_cm_get(neigh))
 				ipoib_cm_set(neigh, ipoib_cm_create_tx(dev, path, neigh));
 			if (!ipoib_cm_get(neigh)) {
-				list_del(&neigh->list);
 				ipoib_neigh_free(neigh);
 				goto err_drop;
 			}
@@ -639,7 +637,7 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 		neigh->ah  = NULL;
 
 		if (!path->query && path_rec_start(dev, path))
-			goto err_list;
+			goto err_path;
 
 		__skb_queue_tail(&neigh->queue, skb);
 	}
@@ -648,9 +646,6 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 	ipoib_neigh_put(neigh);
 	return;
 
-err_list:
-	list_del(&neigh->list);
-
 err_path:
 	ipoib_neigh_free(neigh);
 err_drop:
@@ -1098,6 +1093,8 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
 			rcu_assign_pointer(*np,
 					   rcu_dereference_protected(neigh->hnext,
 								     lockdep_is_held(&priv->lock)));
+			/* remove from parent list */
+			list_del(&neigh->list);
 			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
 			return;
 		} else {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
