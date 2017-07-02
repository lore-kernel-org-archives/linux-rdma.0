From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1] RDMA/rw: Remove force_mr module parameter
Date: Sun,  2 Jul 2017 09:24:25 +0300
Message-ID: <20170702062425.6780-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The force_mr module parameter was introduced in the commit
a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API").

>From the beginning, the fourth parameter of the module_param_named
macro was set to 0. Passing 0 there means that module parameter is not
created and that adding "options ib_core force_mr=1" to a modprobe.conf
file has no effect.

Since the force_mr parameter is intended for debug and unlikely will be used
by anyone except developers and exposure of module parameter can limit
ourselves in debug ability. The preferable way will be to remove this
module parameter entirely and don't fix the file permission parameter
(the fourth parameter).

Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Chuck,

I added your SOB to this commit, because this commit message was highly influenced
by yours initial patch.

Please let me know if it is fine with you.

Thanks

Changelog:
v0->v1:
1. Rewrote commit message and comment in the code
2. Removed extra blank line
---
 drivers/infiniband/core/rw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index dbfd854c32c9..447099574ede 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -22,9 +22,10 @@ enum {
 	RDMA_RW_SIG_MR,
 };

+/*
+ * Debug option to force MR registration logic.
+ */
 static bool rdma_rw_force_mr;
-module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
-MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");

 /*
  * Check if the device might use memory registration.  This is currently only
@@ -503,7 +504,7 @@ struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		rdma_rw_update_lkey(&ctx->sig->data, true);
 		if (ctx->sig->prot.mr)
 			rdma_rw_update_lkey(&ctx->sig->prot, true);
-
+
 		ctx->sig->sig_mr->need_inval = true;
 		ib_update_fast_reg_key(ctx->sig->sig_mr,
 			ib_inc_rkey(ctx->sig->sig_mr->lkey));
--
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
