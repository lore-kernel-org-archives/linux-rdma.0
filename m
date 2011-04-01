From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] ibacm: Allocate address handles dynamically when needed
Date: Fri, 1 Apr 2011 16:58:13 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC950162@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC95015A@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC95015A-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibacm allocates an address handle for every remote destination
that it tracks.  However, under normal operation, the handle
is used infrequently - typically only once by the target
service to send a response and not at all on the initiator
service.  Avoid the overhead of having 1 address handle per
destination by allocating them dynamically only when they are needed.

The exceptions to this are the address handles allocated to
communicate with the SA and the primary multicast group.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   55 +++++++++++++++++++++++++------------------------------
 1 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index fe42498..53a8e7b 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -164,6 +164,7 @@ struct acm_send_msg
 	DLIST_ENTRY          entry;
 	struct acm_ep        *ep;
 	struct acm_dest      *dest;
+	struct ibv_ah        *ah;
 	void                 *context;
 	void                 (*resp_handler)(struct acm_send_msg *req,
 	                                     struct ibv_wc *wc, struct acm_mad *resp);
@@ -449,20 +450,30 @@ acm_alloc_send(struct acm_ep *ep, struct acm_dest *dest, size_t size)
 	msg->mr = ibv_reg_mr(ep->port->dev->pd, msg->data, size, 0);
 	if (!msg->mr) {
 		acm_log(0, "ERROR - failed to register send buffer\n");
-		goto err;
+		goto err1;
+	}
+
+	if (!dest->ah) {
+		msg->ah = ibv_create_ah(ep->port->dev->pd, &dest->av);
+		if (!msg->ah) {
+			acm_log(0, "ERROR - unable to create ah\n");
+			goto err2;
+		}
+		msg->wr.wr.ud.ah = msg->ah;
+	} else {
+		msg->wr.wr.ud.ah = dest->ah;
 	}
 
+	acm_log(2, "get dest %s\n", dest->name);
+	(void) atomic_inc(&dest->refcnt);
+	msg->dest = dest;
+
 	msg->wr.next = NULL;
 	msg->wr.sg_list = &msg->sge;
 	msg->wr.num_sge = 1;
 	msg->wr.opcode = IBV_WR_SEND;
 	msg->wr.send_flags = IBV_SEND_SIGNALED;
 	msg->wr.wr_id = (uintptr_t) msg;
-
-	acm_log(2, "get dest %s\n", dest->name);
-	(void) atomic_inc(&dest->refcnt);
-	msg->dest = dest;
-	msg->wr.wr.ud.ah = dest->ah;
 	msg->wr.wr.ud.remote_qpn = dest->remote_qpn;
 	msg->wr.wr.ud.remote_qkey = ACM_QKEY;
 
@@ -471,7 +482,10 @@ acm_alloc_send(struct acm_ep *ep, struct acm_dest *dest, size_t size)
 	msg->sge.addr = (uintptr_t) msg->data;
 	acm_log(2, "%p\n", msg);
 	return msg;
-err:
+
+err2:
+	ibv_dereg_mr(msg->mr);
+err1:
 	free(msg);
 	return NULL;
 }
@@ -490,6 +504,8 @@ acm_init_send_req(struct acm_send_msg *msg, void *context,
 static void acm_free_send(struct acm_send_msg *msg)
 {
 	acm_log(2, "%p\n", msg);
+	if (msg->ah)
+		ibv_destroy_ah(msg->ah);
 	ibv_dereg_mr(msg->mr);
 	acm_put_dest(msg->dest);
 	free(msg);
@@ -774,7 +790,6 @@ static uint8_t
 acm_record_acm_route(struct acm_ep *ep, struct acm_dest *dest)
 {
 	int i;
-	uint8_t status;
 
 	acm_log(2, "\n");
 	for (i = 0; i < MAX_EP_MC; i++) {
@@ -789,18 +804,8 @@ acm_record_acm_route(struct acm_ep *ep, struct acm_dest *dest)
 	dest->path = ep->mc_dest[i].path;
 	dest->path.dgid = dest->av.grh.dgid;
 	dest->path.dlid = htons(dest->av.dlid);
-
-	dest->ah = ibv_create_ah(ep->port->dev->pd, &dest->av);
-	if (!dest->ah) {
-		acm_log(0, "ERROR - failed to create ah\n");
-		dest->state = ACM_INIT;
-		status = ACM_STATUS_ENOMEM;
-	} else {
-		dest->state = ACM_READY;
-		status = ACM_STATUS_SUCCESS;
-	}
-	
-	return status;
+	dest->state = ACM_READY;
+	return ACM_STATUS_SUCCESS;
 }
 
 static void acm_init_path_query(struct ib_sa_mad *mad)
@@ -1096,15 +1101,6 @@ acm_dest_sa_resp(struct acm_send_msg *msg, struct ibv_wc *wc, struct acm_mad *ma
 	if (!status) {
 		memcpy(&dest->path, sa_mad->data, sizeof(dest->path));
 		acm_init_path_av(msg->ep->port, dest);
-		if (dest->remote_qpn) {
-			dest->ah = ibv_create_ah(msg->ep->port->dev->pd, &dest->av);
-			if (!dest->ah) {
-				acm_log(0, "ERROR - failed to create ah\n");
-				status = ACM_STATUS_ENOMEM;
-			}
-		}
-	}
-	if (!status) {
 		dest->state = ACM_READY;
 	} else {
 		dest->state = ACM_INIT;
@@ -1164,7 +1160,6 @@ acm_process_addr_req(struct acm_ep *ep, struct ibv_wc *wc, struct acm_mad *mad)
 			break;
 
 		acm_log(2, "src service has new qp, resetting\n");
-		ibv_destroy_ah(dest->ah); // TODO: ah could be in use
 		/* fall through */
 	case ACM_INIT:
 	case ACM_QUERY_ADDR:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
