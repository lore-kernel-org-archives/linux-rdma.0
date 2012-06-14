From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: QP type check on received REQs should be AND not OR
Date: Thu, 14 Jun 2012 20:49:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A317D1@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change || check to && when checking the QP type in a received
connection request against the listening endpoint.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Found by code inspection.

 drivers/infiniband/core/cma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 467f2fb..41f3351 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1189,7 +1189,7 @@ static void cma_set_req_event_data(struct rdma_cm_event *event,
 
 static int cma_check_req_qp_type(struct rdma_cm_id *id, struct ib_cm_event *ib_event)
 {
-	return (((ib_event->event == IB_CM_REQ_RECEIVED) ||
+	return (((ib_event->event == IB_CM_REQ_RECEIVED) &&
 		 (ib_event->param.req_rcvd.qp_type == id->qp_type)) ||
 		((ib_event->event == IB_CM_SIDR_REQ_RECEIVED) &&
 		 (id->qp_type == IB_QPT_UD)) ||


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
