From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core 2/4] libqedr: fail post_send on WR overflow
Date: Thu, 27 Apr 2017 09:11:06 +0300
Message-ID: <1493273468-23774-3-git-send-email-Ram.Amrani@cavium.com>
References: <1493273468-23774-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493273468-23774-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Post send will fail if it is full, thus preventing an overflow.
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 8d94a12..7419540 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -70,6 +70,11 @@ static void qelr_inc_sw_prod_u16(struct qelr_qp_hwq_info *info)
 	info->prod = (info->prod + 1) % info->max_wr;
 }
 
+static inline int qelr_wq_is_full(struct qelr_qp_hwq_info *info)
+{
+	return (((info->prod + 1) % info->max_wr) == info->cons);
+}
+
 int qelr_query_device(struct ibv_context *context,
 		      struct ibv_device_attr *attr)
 {
@@ -1144,6 +1149,14 @@ static inline int qelr_can_post_send(struct qelr_devctx *cxt,
 		return -EINVAL;
 	}
 
+	/* WR overflow */
+	if (qelr_wq_is_full(&qp->sq)) {
+		DP_ERR(cxt->dbg_fp,
+		       "error: WQ is full. Post send on QP %p failed (this error appears only once)\n",
+		       qp);
+		return -ENOMEM;
+	}
+
 	/* WQE overflow */
 	if (qelr_chain_get_elem_left_u32(&qp->sq.chain) <
 			QELR_MAX_SQ_WQE_SIZE) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
