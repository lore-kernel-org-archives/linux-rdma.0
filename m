From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V3 5/5] xprtrdma: Use transport independent MR allocation
Date: Sun, 05 Jul 2015 18:22:25 -0500
Message-ID: <20150705232224.12029.12079.stgit@build2.ogc.int>
References: <20150705231831.12029.80307.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150705231831.12029.80307.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use rdma_get_dma_mr() to allocat DMA MRs.

Use rdma_fast_reg_access_flags() to compute the needed access flags in
fast register operations.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/frwr_ops.c |    6 ++++--
 net/sunrpc/xprtrdma/verbs.c    |   11 +++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index d234521..240880e 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -227,8 +227,10 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	fastreg_wr.wr.fast_reg.page_list_len = page_no;
 	fastreg_wr.wr.fast_reg.length = len;
 	fastreg_wr.wr.fast_reg.access_flags = writing ?
-				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
-				IB_ACCESS_REMOTE_READ;
+		rdma_fast_reg_access_flags(r_xprt->rx_ia.ri_pd,
+					   RDMA_MRR_WRITE_DEST, 0) :
+		rdma_fast_reg_access_flags(r_xprt->rx_ia.ri_pd,
+					   RDMA_MRR_READ_SOURCE, 0);
 	key = (u8)(mr->rkey & 0x000000FF);
 	ib_update_fast_reg_key(mr, ++key);
 	fastreg_wr.wr.fast_reg.rkey = mr->rkey;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 52df265..4ab5dc9 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -499,7 +499,7 @@ rpcrdma_clean_cq(struct ib_cq *cq)
 int
 rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 {
-	int rc, mem_priv;
+	int rc, mem_roles;
 	struct rpcrdma_ia *ia = &xprt->rx_ia;
 	struct ib_device_attr *devattr = &ia->ri_devattr;
 
@@ -562,17 +562,16 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
 		break;
 	case RPCRDMA_ALLPHYSICAL:
 		ia->ri_ops = &rpcrdma_physical_memreg_ops;
-		mem_priv = IB_ACCESS_LOCAL_WRITE |
-				IB_ACCESS_REMOTE_WRITE |
-				IB_ACCESS_REMOTE_READ;
+		mem_roles = RDMA_MRR_SEND | RDMA_MRR_RECV |
+			    RDMA_MRR_WRITE_DEST | RDMA_MRR_READ_SOURCE;
 		goto register_setup;
 	case RPCRDMA_MTHCAFMR:
 		ia->ri_ops = &rpcrdma_fmr_memreg_ops;
 		if (ia->ri_have_dma_lkey)
 			break;
-		mem_priv = IB_ACCESS_LOCAL_WRITE;
+		mem_roles = RDMA_MRR_SEND | RDMA_MRR_RECV;
 	register_setup:
-		ia->ri_bind_mem = ib_get_dma_mr(ia->ri_pd, mem_priv);
+		ia->ri_bind_mem = rdma_get_dma_mr(ia->ri_pd, mem_roles, 0);
 		if (IS_ERR(ia->ri_bind_mem)) {
 			printk(KERN_ALERT "%s: ib_get_dma_mr for "
 				"phys register failed with %lX\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
