From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdma/cm: Fix crash in cma_req_handler
Date: Mon, 22 Aug 2011 19:28:28 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E471B2@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The rdma_cm uses the local qp_type to determine how to
process an incoming request.  This can result in an
incoming REQ being treated as a SIDR REQ and vice versa.
Fix this by switching off the event type instead, and for
good measure verify that the listener supports the incoming
connection request.

This problem showed up when a user space application
mismatched the qp types between a client and server app.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Please consider queuing for 3.1.

 drivers/infiniband/core/cma.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b6a33b3..db58478 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1181,6 +1181,15 @@ static void cma_set_req_event_data(struct rdma_cm_event *event,
 	event->param.conn.qp_num = req_data->remote_qpn;
 }
 
+static int cma_check_req_qp_type(struct rdma_cm_id *id, struct ib_cm_event *ib_event)
+{
+	return (((ib_event->event == IB_CM_REQ_RECEIVED) ||
+		 (ib_event->param.req_rcvd.qp_type == id->qp_type)) ||
+		((ib_event->event == IB_CM_SIDR_REQ_RECEIVED) &&
+		 (id->qp_type == IB_QPT_UD)) ||
+		(!id->qp_type));
+}
+
 static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 {
 	struct rdma_id_private *listen_id, *conn_id;
@@ -1188,13 +1197,16 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	int offset, ret;
 
 	listen_id = cm_id->context;
+	if (!cma_check_req_qp_type(&listen_id->id, ib_event))
+		return -EINVAL;
+
 	if (cma_disable_callback(listen_id, RDMA_CM_LISTEN))
 		return -ECONNABORTED;
 
 	memset(&event, 0, sizeof event);
 	offset = cma_user_data_offset(listen_id->id.ps);
 	event.event = RDMA_CM_EVENT_CONNECT_REQUEST;
-	if (listen_id->id.qp_type == IB_QPT_UD) {
+	if (ib_event->event == IB_CM_SIDR_REQ_RECEIVED) {
 		conn_id = cma_new_udp_id(&listen_id->id, ib_event);
 		event.param.ud.private_data = ib_event->private_data + offset;
 		event.param.ud.private_data_len =


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
