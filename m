From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] IB/rxe: remove unnecessary parameter in rxe_av_to_attr
Date: Wed, 31 Jan 2018 06:06:56 -0500
Message-ID: <1517396819-29597-4-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the function rxe_av_to_attr, the parameter rxe is
not used. So it is removed.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 3 +--
 drivers/infiniband/sw/rxe/rxe_loc.h   | 3 +--
 drivers/infiniband/sw/rxe/rxe_qp.c    | 6 ++----
 drivers/infiniband/sw/rxe/rxe_verbs.c | 3 +--
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 11e7bed..26ed069 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -61,8 +61,7 @@ void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 	av->port_num = port_num;
 }
 
-int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
-		   struct rdma_ah_attr *attr)
+int rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr)
 {
 	attr->type = RDMA_AH_ATTR_TYPE_ROCE;
 	memcpy(rdma_ah_retrieve_grh(attr), &av->grh, sizeof(av->grh));
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index ba25c81..ef8da26 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -41,8 +41,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr);
 void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 		     struct rdma_ah_attr *attr);
 
-int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
-		   struct rdma_ah_attr *attr);
+int rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr);
 
 int rxe_av_fill_ip_info(struct rxe_dev *rxe,
 			struct rxe_av *av,
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 11655a0..5a2d339 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -764,8 +764,6 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 /* called by the query qp verb */
 int rxe_qp_to_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask)
 {
-	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
-
 	*attr = qp->attr;
 
 	attr->rq_psn				= qp->resp.psn;
@@ -780,8 +778,8 @@ int rxe_qp_to_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask)
 		attr->cap.max_recv_sge		= qp->rq.max_sge;
 	}
 
-	rxe_av_to_attr(rxe, &qp->pri_av, &attr->ah_attr);
-	rxe_av_to_attr(rxe, &qp->alt_av, &attr->alt_ah_attr);
+	rxe_av_to_attr(&qp->pri_av, &attr->ah_attr);
+	rxe_av_to_attr(&qp->alt_av, &attr->alt_ah_attr);
 
 	if (qp->req.state == QP_STATE_DRAIN) {
 		attr->sq_draining = 1;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 1cc8e0b..ccb5721 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -334,12 +334,11 @@ static int rxe_modify_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 
 static int rxe_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
-	struct rxe_dev *rxe = to_rdev(ibah->device);
 	struct rxe_ah *ah = to_rah(ibah);
 
 	memset(attr, 0, sizeof(*attr));
 	attr->type = ibah->type;
-	rxe_av_to_attr(rxe, &ah->av, attr);
+	rxe_av_to_attr(&ah->av, attr);
 	return 0;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
