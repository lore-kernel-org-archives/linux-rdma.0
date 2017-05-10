From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/14] RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails
Date: Wed, 10 May 2017 03:45:34 -0700
Message-ID: <1494413139-11883-10-git-send-email-selvin.xavier@broadcom.com>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494413139-11883-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do not free context table entry if delete GID fails. Stack may call
back the add_gid for the same context again which could result in
panic

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 61703f3..525f4b0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -375,15 +375,17 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
 			return -EINVAL;
 		ctx->refcnt--;
 		if (!ctx->refcnt) {
-			rc = bnxt_qplib_del_sgid
-					(sgid_tbl,
-					 &sgid_tbl->tbl[ctx->idx], true);
-			if (rc)
+			rc = bnxt_qplib_del_sgid(sgid_tbl,
+						 &sgid_tbl->tbl[ctx->idx],
+						 true);
+			if (rc) {
 				dev_err(rdev_to_dev(rdev),
 					"Failed to remove GID: %#x", rc);
-			ctx_tbl = sgid_tbl->ctx;
-			ctx_tbl[ctx->idx] = NULL;
-			kfree(ctx);
+			} else {
+				ctx_tbl = sgid_tbl->ctx;
+				ctx_tbl[ctx->idx] = NULL;
+				kfree(ctx);
+			}
 		}
 	} else {
 		return -EINVAL;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
