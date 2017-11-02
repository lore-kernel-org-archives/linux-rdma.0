From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Do not block QP attr_masks used by older
 kernels
Date: Thu, 2 Nov 2017 15:50:31 -0600
Message-ID: <20171102215031.GY18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At least the RDMA CM in 4.3 will give user space structs with these bits
set. Those kernels require user space to pass those set bits back to the
kernel. Blocking them causes RDMA CM to be unusable on older kernels.

Fixes: 3ca7a1031486 ("ibverbs: Add support for packet pacing")
Reported-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
---
 libibverbs/cmd.c   | 12 ++++++------
 libibverbs/verbs.h |  9 +++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 713a13c0f272b3..fbe822324c9dd5 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1182,10 +1182,10 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	struct ibv_query_qp_resp resp;
 
 	/*
-	 * Masks over IBV_QP_DEST_QPN are not supported by
-	 * that not extended command.
+	 * Starting with IB_QP_RATE_LIMIT the attribute must go through the
+	 * _ex path.
 	 */
-	if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
+	if (attr_mask & ~(IBV_QP_RATE_LIMIT - 1))
 		return EOPNOTSUPP;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_QP, &resp, sizeof resp);
@@ -1352,10 +1352,10 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		      struct ibv_modify_qp *cmd, size_t cmd_size)
 {
 	/*
-	 * Masks over IBV_QP_DEST_QPN are only supported by
-	 * ibv_cmd_modify_qp_ex.
+	 * Starting with IB_QP_RATE_LIMIT the attribute must go through the
+	 * _ex path.
 	 */
-	if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
+	if (attr_mask & ~(IBV_QP_RATE_LIMIT - 1))
 		return EOPNOTSUPP;
 
 	IBV_INIT_CMD(cmd, cmd_size, MODIFY_QP);
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 1ab747bb757cf3..2a2264d300e1ca 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -909,6 +909,15 @@ enum ibv_qp_attr_mask {
 	IBV_QP_PATH_MIG_STATE		= 1 << 18,
 	IBV_QP_CAP			= 1 << 19,
 	IBV_QP_DEST_QPN			= 1 << 20,
+#if 0
+	/* These bits were supported on older kernels, but never exposed to
+	 * user space:
+	 */
+	_IBV_QP_COMPAT1			= 1 << 21,
+	_IBV_QP_COMPAT2			= 1 << 22,
+	_IBV_QP_COMPAT3			= 1 << 23,
+	_IBV_QP_COMPAT3			= 1 << 24,
+#endif
 	IBV_QP_RATE_LIMIT		= 1 << 25,
 };
 
-- 
2.7.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
