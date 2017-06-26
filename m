From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 1/3] RDMA/qedr: Prevent memory overrun in verbs' user responses
Date: Mon, 26 Jun 2017 19:05:04 +0300
Message-ID: <1498493106-28604-2-git-send-email-Ram.Amrani@cavium.com>
References: <1498493106-28604-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498493106-28604-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wrap ib_copy_to_udata with a function that ensures that the data
being copied over to user space isn't longer than the allowed.

Fixes: cecbcddf6461 ("qedr: Add support for QP verbs")
Fixes: a7efd7773e31 ("qedr: Add support for PD,PKEY and CQ verbs")
Fixes: ac1b36e55a51 ("qedr: Add support for user context verbs")
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 17685cf..3ec861c 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -53,6 +53,14 @@
 
 #define DB_ADDR_SHIFT(addr)		((addr) << DB_PWM_ADDR_OFFSET_SHIFT)
 
+static inline int qedr_ib_copy_to_udata(struct ib_udata *udata, void *src,
+					size_t len)
+{
+	size_t min_len = min_t(size_t, len, udata->outlen);
+
+	return ib_copy_to_udata(udata, src, min_len);
+}
+
 int qedr_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
 	if (index > QEDR_ROCE_PKEY_TABLE_LEN)
@@ -378,7 +386,7 @@ struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
 	uresp.sges_per_srq_wr = dev->attr.max_srq_sge;
 	uresp.max_cqes = QEDR_MAX_CQES;
 
-	rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (rc)
 		goto err;
 
@@ -499,7 +507,7 @@ struct ib_pd *qedr_alloc_pd(struct ib_device *ibdev,
 
 		uresp.pd_id = pd_id;
 
-		rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+		rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 		if (rc) {
 			DP_ERR(dev, "copy error pd_id=0x%x.\n", pd_id);
 			dev->ops->rdma_dealloc_pd(dev->rdma_ctx, pd_id);
@@ -722,7 +730,7 @@ static int qedr_copy_cq_uresp(struct qedr_dev *dev,
 	uresp.db_offset = DB_ADDR_SHIFT(DQ_PWM_OFFSET_UCM_RDMA_CQ_CONS_32BIT);
 	uresp.icid = cq->icid;
 
-	rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (rc)
 		DP_ERR(dev, "copy error cqid=0x%x.\n", cq->icid);
 
@@ -1228,7 +1236,7 @@ static int qedr_copy_qp_uresp(struct qedr_dev *dev,
 	uresp.atomic_supported = dev->atomic_cap != IB_ATOMIC_NONE;
 	uresp.qp_id = qp->qp_id;
 
-	rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
+	rc = qedr_ib_copy_to_udata(udata, &uresp, sizeof(uresp));
 	if (rc)
 		DP_ERR(dev,
 		       "create qp: failed a copy to user space with qp icid=0x%x.\n",
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
