From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/rxe: Remove unneeded check
Date: Fri, 21 Jul 2017 22:13:19 +0300
Message-ID: <20170721191319.2966-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Port validation is performed in ib_core, no need to duplicate it here.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 5bddf469361b..3f6122e37831 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -38,13 +38,6 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr)
 {
 	struct rxe_port *port;
 
-	if (rdma_ah_get_port_num(attr) != 1) {
-		pr_info("invalid port_num = %d\n", rdma_ah_get_port_num(attr));
-		return -EINVAL;
-	}
-
-	port = &rxe->port;
-
 	if (rdma_ah_get_ah_flags(attr) & IB_AH_GRH) {
 		u8 sgid_index = rdma_ah_read_grh(attr)->sgid_index;
 
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
