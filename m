From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 37/45] RDMA/qedr: Remove set-but-not-used variables
Date: Wed, 11 Oct 2017 10:49:19 -0700
Message-ID: <20171011174927.25113-38-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 5acb9eab64ed..b26aa88dab48 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1447,13 +1447,11 @@ static int qedr_create_user_qp(struct qedr_dev *dev,
 	struct qed_rdma_create_qp_out_params out_params;
 	struct qedr_pd *pd = get_qedr_pd(ibpd);
 	struct ib_ucontext *ib_ctx = NULL;
-	struct qedr_ucontext *ctx = NULL;
 	struct qedr_create_qp_ureq ureq;
 	int alloc_and_init = rdma_protocol_roce(&dev->ibdev, 1);
 	int rc = -EINVAL;
 
 	ib_ctx = ibpd->uobject->context;
-	ctx = get_qedr_ucontext(ib_ctx);
 
 	memset(&ureq, 0, sizeof(ureq));
 	rc = ib_copy_from_udata(&ureq, udata, sizeof(ureq));
@@ -2602,7 +2600,6 @@ static struct qedr_mr *__qedr_alloc_mr(struct ib_pd *ibpd,
 struct ib_mr *qedr_alloc_mr(struct ib_pd *ibpd,
 			    enum ib_mr_type mr_type, u32 max_num_sg)
 {
-	struct qedr_dev *dev;
 	struct qedr_mr *mr;
 
 	if (mr_type != IB_MR_TYPE_MEM_REG)
@@ -2613,8 +2610,6 @@ struct ib_mr *qedr_alloc_mr(struct ib_pd *ibpd,
 	if (IS_ERR(mr))
 		return ERR_PTR(-EINVAL);
 
-	dev = mr->dev;
-
 	return &mr->ibmr;
 }
 
@@ -3109,7 +3104,7 @@ static int __qedr_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		break;
 	case IB_WR_RDMA_READ_WITH_INV:
 		SET_FIELD2(wqe->flags, RDMA_SQ_RDMA_WQE_1ST_READ_INV_FLG, 1);
-		/* fallthrough... same is identical to RDMA READ */
+		/* fallthrough -- same is identical to RDMA READ */
 
 	case IB_WR_RDMA_READ:
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_RD;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
