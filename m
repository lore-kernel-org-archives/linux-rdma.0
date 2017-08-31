From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 8/8] bnxt_re: Don't issue cmd to delete GID for QP1 GID entry before the QP is destroyed
Date: Thu, 31 Aug 2017 09:27:35 +0530
Message-ID: <20170831035735.19595-9-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

FW needs the 0th GID Entry in the Table to be preserved before
it's corresponding QP1 is deleted, else it will fail the cmd.
Check for the same and return to prevent error msg being logged for
cmd failure.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 94ab9e1..a5f1ada 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -314,6 +314,7 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
 	struct bnxt_re_gid_ctx *ctx, **ctx_tbl;
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
 	struct bnxt_qplib_sgid_tbl *sgid_tbl = &rdev->qplib_res.sgid_tbl;
+	struct bnxt_qplib_gid *gid_to_del;
 
 	/* Delete the entry from the hardware */
 	ctx = *context;
@@ -323,11 +324,25 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
 	if (sgid_tbl && sgid_tbl->active) {
 		if (ctx->idx >= sgid_tbl->max)
 			return -EINVAL;
+		gid_to_del = &sgid_tbl->tbl[ctx->idx];
+		/* DEL_GID is called in WQ context(netdevice_event_work_handler)
+		 * or via the ib_unregister_device path. In the former case QP1
+		 * may not be destroyed yet, in which case just return as FW
+		 * needs that entry to be present and will fail it's deletion.
+		 * We could get invoked again after QP1 is destroyed OR get an
+		 * ADD_GID call with a different GID value for the same index
+		 * where we issue MODIFY_GID cmd to update the GID entry -- TBD
+		 */
+		if (ctx->idx == 0 &&
+		    rdma_link_local_addr((struct in6_addr *)gid_to_del) &&
+		    ctx->refcnt == 1 && rdev->qp1_sqp) {
+			dev_dbg(rdev_to_dev(rdev),
+				"Trying to delete GID0 while QP1 is alive\n");
+			return -EFAULT;
+		}
 		ctx->refcnt--;
 		if (!ctx->refcnt) {
-			rc = bnxt_qplib_del_sgid(sgid_tbl,
-						 &sgid_tbl->tbl[ctx->idx],
-						 true);
+			rc = bnxt_qplib_del_sgid(sgid_tbl, gid_to_del, true);
 			if (rc) {
 				dev_err(rdev_to_dev(rdev),
 					"Failed to remove GID: %#x", rc);
@@ -811,6 +826,8 @@ int bnxt_re_destroy_qp(struct ib_qp *ib_qp)
 
 		kfree(rdev->sqp_ah);
 		kfree(rdev->qp1_sqp);
+		rdev->qp1_sqp = NULL;
+		rdev->sqp_ah = NULL;
 	}
 
 	if (!IS_ERR_OR_NULL(qp->rumem))
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
