From: Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/CM: fix memory corruption by avoiding unnecessary memset
Date: Thu,  2 Nov 2017 16:21:44 -0700
Message-ID: <20171102232144.13668-1-qing.huang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The size of path array could be dynamic. However the fixed number(2)
of memset could cause memory corruption by writing into wrong memory
space.

Fixes: 9fdca4da4d8c (IB/SA: Split struct sa_path_rec based on IB ands
	ROCE specific fields)

Signed-off-by: Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4c4b465..af4f6a0 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1856,7 +1856,9 @@ static int cm_req_handler(struct cm_work *work)
 	cm_process_routed_req(req_msg, work->mad_recv_wc->wc);
 
 	memset(&work->path[0], 0, sizeof(work->path[0]));
-	memset(&work->path[1], 0, sizeof(work->path[1]));
+	if (cm_req_has_alt_path(req_msg))
+		memset(&work->path[1], 0, sizeof(work->path[1]));
+
 	grh = rdma_ah_read_grh(&cm_id_priv->av.ah_attr);
 	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
 				work->port->port_num,
@@ -3823,8 +3825,8 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 
 	switch (mad_recv_wc->recv_buf.mad->mad_hdr.attr_id) {
 	case CM_REQ_ATTR_ID:
-		paths = 1 + (((struct cm_req_msg *) mad_recv_wc->recv_buf.mad)->
-						    alt_local_lid != 0);
+		paths = 1 + cm_req_has_alt_path(
+				(struct cm_req_msg *)mad_recv_wc->recv_buf.mad);
 		event = IB_CM_REQ_RECEIVED;
 		break;
 	case CM_MRA_ATTR_ID:
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
