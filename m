From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] IB/rxe: remove redudant parameter in function
Date: Wed, 31 Jan 2018 06:06:54 -0500
Message-ID: <1517396819-29597-2-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the function rxe_av_from_attr, the parameter rxe
is not used. So it is removed.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 4 ++--
 drivers/infiniband/sw/rxe/rxe_loc.h   | 4 ++--
 drivers/infiniband/sw/rxe/rxe_qp.c    | 5 ++---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 1cc9e2e..8accd5d 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -52,8 +52,8 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr)
 	return 0;
 }
 
-int rxe_av_from_attr(struct rxe_dev *rxe, u8 port_num,
-		     struct rxe_av *av, struct rdma_ah_attr *attr)
+int rxe_av_from_attr(u8 port_num, struct rxe_av *av,
+		     struct rdma_ah_attr *attr)
 {
 	memset(av, 0, sizeof(*av));
 	memcpy(&av->grh, rdma_ah_read_grh(attr),
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index d7472a4..4eb0ff1 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -38,8 +38,8 @@
 
 int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr);
 
-int rxe_av_from_attr(struct rxe_dev *rxe, u8 port_num,
-		     struct rxe_av *av, struct rdma_ah_attr *attr);
+int rxe_av_from_attr(u8 port_num, struct rxe_av *av,
+		     struct rdma_ah_attr *attr);
 
 int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
 		   struct rdma_ah_attr *attr);
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 4469592..11655a0 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -633,8 +633,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		ib_get_cached_gid(&rxe->ib_dev, 1,
 				  rdma_ah_read_grh(&attr->ah_attr)->sgid_index,
 				  &sgid, &sgid_attr);
-		rxe_av_from_attr(rxe, attr->port_num, &qp->pri_av,
-				 &attr->ah_attr);
+		rxe_av_from_attr(attr->port_num, &qp->pri_av, &attr->ah_attr);
 		rxe_av_fill_ip_info(rxe, &qp->pri_av, &attr->ah_attr,
 				    &sgid_attr, &sgid);
 		if (sgid_attr.ndev)
@@ -648,7 +647,7 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		ib_get_cached_gid(&rxe->ib_dev, 1, sgid_index,
 				  &sgid, &sgid_attr);
 
-		rxe_av_from_attr(rxe, attr->alt_port_num, &qp->alt_av,
+		rxe_av_from_attr(attr->alt_port_num, &qp->alt_av,
 				 &attr->alt_ah_attr);
 		rxe_av_fill_ip_info(rxe, &qp->alt_av, &attr->alt_ah_attr,
 				    &sgid_attr, &sgid);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index d03002b..abbc983 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -271,7 +271,7 @@ static int rxe_init_av(struct rxe_dev *rxe, struct rdma_ah_attr *attr,
 		return err;
 	}
 
-	err = rxe_av_from_attr(rxe, rdma_ah_get_port_num(attr), av, attr);
+	err = rxe_av_from_attr(rdma_ah_get_port_num(attr), av, attr);
 	if (!err)
 		err = rxe_av_fill_ip_info(rxe, av, attr, &sgid_attr, &sgid);
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
