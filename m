From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] IB/rxe: remove redudant parameter in rxe_av_fill_ip_info
Date: Wed, 31 Jan 2018 06:06:59 -0500
Message-ID: <1517396819-29597-7-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the function rxe_av_fill_ip_info, the parameter rxe is not used.
So it is removed.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 3 +--
 drivers/infiniband/sw/rxe/rxe_loc.h   | 3 +--
 drivers/infiniband/sw/rxe/rxe_qp.c    | 4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index c33aa41..7522d1a 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -69,8 +69,7 @@ void rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr)
 	rdma_ah_set_port_num(attr, av->port_num);
 }
 
-void rxe_av_fill_ip_info(struct rxe_dev *rxe,
-			struct rxe_av *av,
+void rxe_av_fill_ip_info(struct rxe_av *av,
 			struct rdma_ah_attr *attr,
 			struct ib_gid_attr *sgid_attr,
 			union ib_gid *sgid)
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 061fe60..ea1aaa6 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -43,8 +43,7 @@ void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 
 void rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr);
 
-void rxe_av_fill_ip_info(struct rxe_dev *rxe,
-			struct rxe_av *av,
+void rxe_av_fill_ip_info(struct rxe_av *av,
 			struct rdma_ah_attr *attr,
 			struct ib_gid_attr *sgid_attr,
 			union ib_gid *sgid);
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 5a2d339..4532316 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -634,7 +634,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 				  rdma_ah_read_grh(&attr->ah_attr)->sgid_index,
 				  &sgid, &sgid_attr);
 		rxe_av_from_attr(attr->port_num, &qp->pri_av, &attr->ah_attr);
-		rxe_av_fill_ip_info(rxe, &qp->pri_av, &attr->ah_attr,
+		rxe_av_fill_ip_info(&qp->pri_av, &attr->ah_attr,
 				    &sgid_attr, &sgid);
 		if (sgid_attr.ndev)
 			dev_put(sgid_attr.ndev);
@@ -649,7 +649,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 
 		rxe_av_from_attr(attr->alt_port_num, &qp->alt_av,
 				 &attr->alt_ah_attr);
-		rxe_av_fill_ip_info(rxe, &qp->alt_av, &attr->alt_ah_attr,
+		rxe_av_fill_ip_info(&qp->alt_av, &attr->alt_ah_attr,
 				    &sgid_attr, &sgid);
 		if (sgid_attr.ndev)
 			dev_put(sgid_attr.ndev);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index d6e0d8e..aea13e1 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -272,7 +272,7 @@ static int rxe_init_av(struct rxe_dev *rxe, struct rdma_ah_attr *attr,
 	}
 
 	rxe_av_from_attr(rdma_ah_get_port_num(attr), av, attr);
-	rxe_av_fill_ip_info(rxe, av, attr, &sgid_attr, &sgid);
+	rxe_av_fill_ip_info(av, attr, &sgid_attr, &sgid);
 
 	if (sgid_attr.ndev)
 		dev_put(sgid_attr.ndev);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
