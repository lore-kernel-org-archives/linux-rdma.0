From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] IB/rxe: change the function rxe_av_fill_ip_info to void
Date: Wed, 31 Jan 2018 06:06:58 -0500
Message-ID: <1517396819-29597-6-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function rxe_av_fill_ip_info always returns 0. So the function
type is changed to void.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c    | 4 +---
 drivers/infiniband/sw/rxe/rxe_loc.h   | 2 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c | 4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 9662a77..c33aa41 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -69,7 +69,7 @@ void rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr)
 	rdma_ah_set_port_num(attr, av->port_num);
 }
 
-int rxe_av_fill_ip_info(struct rxe_dev *rxe,
+void rxe_av_fill_ip_info(struct rxe_dev *rxe,
 			struct rxe_av *av,
 			struct rdma_ah_attr *attr,
 			struct ib_gid_attr *sgid_attr,
@@ -78,8 +78,6 @@ int rxe_av_fill_ip_info(struct rxe_dev *rxe,
 	rdma_gid2ip(&av->sgid_addr._sockaddr, sgid);
 	rdma_gid2ip(&av->dgid_addr._sockaddr, &rdma_ah_read_grh(attr)->dgid);
 	av->network_type = ib_gid_to_network_type(sgid_attr->gid_type, sgid);
-
-	return 0;
 }
 
 struct rxe_av *rxe_get_av(struct rxe_pkt_info *pkt)
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index d7e059a..061fe60 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -43,7 +43,7 @@ void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 
 void rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr);
 
-int rxe_av_fill_ip_info(struct rxe_dev *rxe,
+void rxe_av_fill_ip_info(struct rxe_dev *rxe,
 			struct rxe_av *av,
 			struct rdma_ah_attr *attr,
 			struct ib_gid_attr *sgid_attr,
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index ccb5721..d6e0d8e 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -272,11 +272,11 @@ static int rxe_init_av(struct rxe_dev *rxe, struct rdma_ah_attr *attr,
 	}
 
 	rxe_av_from_attr(rdma_ah_get_port_num(attr), av, attr);
-	err = rxe_av_fill_ip_info(rxe, av, attr, &sgid_attr, &sgid);
+	rxe_av_fill_ip_info(rxe, av, attr, &sgid_attr, &sgid);
 
 	if (sgid_attr.ndev)
 		dev_put(sgid_attr.ndev);
-	return err;
+	return 0;
 }
 
 static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
