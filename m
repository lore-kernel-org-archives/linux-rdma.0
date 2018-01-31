From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] IB/rxe: change the function to void from int
Date: Wed, 31 Jan 2018 06:06:57 -0500
Message-ID: <1517396819-29597-5-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since the function rxe_av_to_attr always return 0, the function
type is changed to void.

CC: Srinivas Eeda <srinivas.eeda-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c  | 3 +--
 drivers/infiniband/sw/rxe/rxe_loc.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 26ed069..9662a77 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -61,13 +61,12 @@ void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 	av->port_num = port_num;
 }
 
-int rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr)
+void rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr)
 {
 	attr->type = RDMA_AH_ATTR_TYPE_ROCE;
 	memcpy(rdma_ah_retrieve_grh(attr), &av->grh, sizeof(av->grh));
 	rdma_ah_set_ah_flags(attr, IB_AH_GRH);
 	rdma_ah_set_port_num(attr, av->port_num);
-	return 0;
 }
 
 int rxe_av_fill_ip_info(struct rxe_dev *rxe,
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index ef8da26..d7e059a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -41,7 +41,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr);
 void rxe_av_from_attr(u8 port_num, struct rxe_av *av,
 		     struct rdma_ah_attr *attr);
 
-int rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr);
+void rxe_av_to_attr(struct rxe_av *av, struct rdma_ah_attr *attr);
 
 int rxe_av_fill_ip_info(struct rxe_dev *rxe,
 			struct rxe_av *av,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
