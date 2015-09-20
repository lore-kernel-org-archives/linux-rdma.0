From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-rc 1/4] xprtrdma: Remove ib_get_dma_mr calls
Date: Sun, 20 Sep 2015 12:52:44 +0300
Message-ID: <1442742767-8755-2-git-send-email-sagig@mellanox.com>
References: <1442742767-8755-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442742767-8755-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

since commit 96249d70dd70 ("IB/core:
Guarantee that a local_dma_lkey is available") The PD now
has a local_dma_lkey member which completely replaces
ib_get_dma_mr, use it instead.

In FRWR memreg mode, we assumed that the device local_dma_lkey
is available.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-nfs <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c      | 19 -------------------
 net/sunrpc/xprtrdma/frwr_ops.c     |  5 -----
 net/sunrpc/xprtrdma/physical_ops.c |  8 --------
 net/sunrpc/xprtrdma/verbs.c        |  1 +
 4 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index cb25c89da623..f1e8dafbd507 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -39,25 +39,6 @@ static int
 fmr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 	    struct rpcrdma_create_data_internal *cdata)
 {
-	struct ib_device_attr *devattr = &ia->ri_devattr;
-	struct ib_mr *mr;
-
-	/* Obtain an lkey to use for the regbufs, which are
-	 * protected from remote access.
-	 */
-	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
-		ia->ri_dma_lkey = ia->ri_device->local_dma_lkey;
-	} else {
-		mr = ib_get_dma_mr(ia->ri_pd, IB_ACCESS_LOCAL_WRITE);
-		if (IS_ERR(mr)) {
-			pr_err("%s: ib_get_dma_mr for failed with %lX\n",
-			       __func__, PTR_ERR(mr));
-			return -ENOMEM;
-		}
-		ia->ri_dma_lkey = ia->ri_dma_mr->lkey;
-		ia->ri_dma_mr = mr;
-	}
-
 	return 0;
 }
 
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index d6653f5d0830..5318951b3b53 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -189,11 +189,6 @@ frwr_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 	struct ib_device_attr *devattr = &ia->ri_devattr;
 	int depth, delta;
 
-	/* Obtain an lkey to use for the regbufs, which are
-	 * protected from remote access.
-	 */
-	ia->ri_dma_lkey = ia->ri_device->local_dma_lkey;
-
 	ia->ri_max_frmr_depth =
 			min_t(unsigned int, RPCRDMA_MAX_DATA_SEGS,
 			      devattr->max_fast_reg_page_list_len);
diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
index 72cf8b15bbb4..5feb63afdb03 100644
--- a/net/sunrpc/xprtrdma/physical_ops.c
+++ b/net/sunrpc/xprtrdma/physical_ops.c
@@ -23,7 +23,6 @@ static int
 physical_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 		 struct rpcrdma_create_data_internal *cdata)
 {
-	struct ib_device_attr *devattr = &ia->ri_devattr;
 	struct ib_mr *mr;
 
 	/* Obtain an rkey to use for RPC data payloads.
@@ -39,13 +38,6 @@ physical_op_open(struct rpcrdma_ia *ia, struct rpcrdma_ep *ep,
 	}
 	ia->ri_dma_mr = mr;
 
-	/* Obtain an lkey to use for regbufs.
-	 */
-	if (devattr->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
-		ia->ri_dma_lkey = ia->ri_device->local_dma_lkey;
-	else
-		ia->ri_dma_lkey = ia->ri_dma_mr->lkey;
-
 	return 0;
 }
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 682996779970..4f405bcad39a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -640,6 +640,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	ep->rep_attr.qp_context = ep;
 	ep->rep_attr.srq = NULL;
 	ep->rep_attr.cap.max_send_wr = cdata->max_requests;
+	ia->ri_dma_lkey = ia->ri_pd->local_dma_lkey;
 	rc = ia->ri_ops->ro_open(ia, ep, cdata);
 	if (rc)
 		return rc;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
