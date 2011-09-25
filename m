From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/4] iw_cm: Propagate ird/ord values upwards
Date: Sun, 25 Sep 2011 20:17:43 +0530
Message-ID: <1316962066-28701-2-git-send-email-kumaras@chelsio.com>
References: <1316962066-28701-1-git-send-email-kumaras@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316962066-28701-1-git-send-email-kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Updates iw_cm_event to support propagating the ird/or
values upwards to the application

Signed-off-by: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    8 ++++++--
 include/rdma/iw_cm.h          |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ca4c5dc..416b2c9 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1328,6 +1328,8 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 		switch (iw_event->status) {
 		case 0:
 			event.event = RDMA_CM_EVENT_ESTABLISHED;
+			event.param.conn.initiator_depth = iw_event->ird;
+			event.param.conn.responder_resources = iw_event->ord;
 			break;
 		case -ECONNRESET:
 		case -ECONNREFUSED:
@@ -1343,6 +1345,8 @@ static int cma_iw_handler(struct iw_cm_id *iw_id, struct iw_cm_event *iw_event)
 		break;
 	case IW_CM_EVENT_ESTABLISHED:
 		event.event = RDMA_CM_EVENT_ESTABLISHED;
+		event.param.conn.initiator_depth = iw_event->ird;
+		event.param.conn.responder_resources = iw_event->ord;
 		break;
 	default:
 		BUG_ON(1);
@@ -1433,8 +1437,8 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	event.event = RDMA_CM_EVENT_CONNECT_REQUEST;
 	event.param.conn.private_data = iw_event->private_data;
 	event.param.conn.private_data_len = iw_event->private_data_len;
-	event.param.conn.initiator_depth = attr.max_qp_init_rd_atom;
-	event.param.conn.responder_resources = attr.max_qp_rd_atom;
+	event.param.conn.initiator_depth = iw_event->ird;
+	event.param.conn.responder_resources = iw_event->ord;
 
 	/*
 	 * Protect against the user destroying conn_id from another thread
diff --git a/include/rdma/iw_cm.h b/include/rdma/iw_cm.h
index 2d0191c..6aba40d 100644
--- a/include/rdma/iw_cm.h
+++ b/include/rdma/iw_cm.h
@@ -54,6 +54,8 @@ struct iw_cm_event {
 	void *private_data;
 	u8 private_data_len;
 	void *provider_data;
+	u8 ord;
+	u8 ird;
 };
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
