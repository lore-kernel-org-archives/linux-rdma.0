From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next] RDMA/rw: Remove force_mr module parameter
Date: Mon, 26 Jun 2017 08:05:08 +0300
Message-ID: <20170626050508.14723-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The force_mr module parameter wasn't exposed to the users
from the beginning with the commit a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API").

Because this variable is for very rare debug while doing bringup of new
ULP and/or converting old ULP to new R/W api. There is no need to expose
that parameter to regular users.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rw.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index dbfd854c32c9..5037ebde62c5 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -22,9 +22,14 @@ enum {
 	RDMA_RW_SIG_MR,
 };

+/*
+ * This parameter is useful for new ULP bringup
+ * and/or conversion to this R/W API.
+ *
+ * Setting it to "true" will allow to mimic with IB devices,
+ * the slow memory registration of iWARP devices.
+ */
 static bool rdma_rw_force_mr;
-module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
-MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");

 /*
  * Check if the device might use memory registration.  This is currently only
@@ -503,7 +508,7 @@ struct ib_send_wr *rdma_rw_ctx_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		rdma_rw_update_lkey(&ctx->sig->data, true);
 		if (ctx->sig->prot.mr)
 			rdma_rw_update_lkey(&ctx->sig->prot, true);
-
+
 		ctx->sig->sig_mr->need_inval = true;
 		ib_update_fast_reg_key(ctx->sig->sig_mr,
 			ib_inc_rkey(ctx->sig->sig_mr->lkey));
--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
