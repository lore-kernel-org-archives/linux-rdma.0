From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 11/43] xprtrdma, svcrdma: Convert to ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:11 +0300
Message-ID: <1437548143-24893-12-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c           | 6 +++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 63f282e..517efed 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -117,7 +117,7 @@ __frwr_recovery_worker(struct work_struct *work)
 	if (ib_dereg_mr(r->r.frmr.fr_mr))
 		goto out_fail;
 
-	r->r.frmr.fr_mr = ib_alloc_fast_reg_mr(pd, depth);
+	r->r.frmr.fr_mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG, depth, 0);
 	if (IS_ERR(r->r.frmr.fr_mr))
 		goto out_fail;
 
@@ -148,7 +148,7 @@ __frwr_init(struct rpcrdma_mw *r, struct ib_pd *pd, struct ib_device *device,
 	struct rpcrdma_frmr *f = &r->r.frmr;
 	int rc;
 
-	f->fr_mr = ib_alloc_fast_reg_mr(pd, depth);
+	f->fr_mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG, depth, 0);
 	if (IS_ERR(f->fr_mr))
 		goto out_mr_err;
 	f->fr_pgl = ib_alloc_fast_reg_page_list(device, depth);
@@ -158,7 +158,7 @@ __frwr_init(struct rpcrdma_mw *r, struct ib_pd *pd, struct ib_device *device,
 
 out_mr_err:
 	rc = PTR_ERR(f->fr_mr);
-	dprintk("RPC:       %s: ib_alloc_fast_reg_mr status %i\n",
+	dprintk("RPC:       %s: ib_alloc_mr status %i\n",
 		__func__, rc);
 	return rc;
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 6b36279..fd933d9 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -738,7 +738,7 @@ static struct svc_rdma_fastreg_mr *rdma_alloc_frmr(struct svcxprt_rdma *xprt)
 	if (!frmr)
 		goto err;
 
-	mr = ib_alloc_fast_reg_mr(xprt->sc_pd, RPCSVC_MAXPAGES);
+	mr = ib_alloc_mr(xprt->sc_pd, IB_MR_TYPE_FAST_REG, RPCSVC_MAXPAGES, 0);
 	if (IS_ERR(mr))
 		goto err_free_frmr;
 
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
