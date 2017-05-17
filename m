From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 09/15] RDMA/bnxt_re: Do not free the ctx_tbl entry if delete GID fails
Date: Wed, 17 May 2017 02:19:45 -0700
Message-ID: <1495012791-5053-10-git-send-email-selvin.xavier@broadcom.com>
References: <1495012791-5053-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495012791-5053-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fix is added only to avoid system crash in some a
specific scenario. When bnxt_re driver is loaded and if
user tries to change interface mac address, delete GID
fails because QP1 is still associated with existing MAC
(default GID). If the above command fails GID tables are
not modified in the h/w or driver, but the GID context memory
is freed. Now, if the user changes the mac back to the original
value, another add_gid comes to the driver where the driver
reports that the GID is already present in its table
and tries to access the context which was already freed.

So, in this case, in order to  avoid NULL pointer de-reference,
this patch removes the context memory free  if delete_gid fails
and the same context memory is re-used in new add_gid.
Memory cleanup will be taken care during driver unload, while
deleting the GID table.

v1 -> v2 : Adds the bug description in commit message

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 6fa6790..9848ab9 100644
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
