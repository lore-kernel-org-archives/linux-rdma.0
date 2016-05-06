From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 01/17] RDMA/iw_cxgb4: Add few history bits for ep
Date: Fri,  6 May 2016 22:17:54 +0530
Message-ID: <1462553290-16422-2-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

- add EP_DISC_FAIL history bit
- add QP_REFED/DEREFED history bits
- Add functions to ref/deref the cm_id and add history bit for the same
- add CLOSE_CON_RPL history

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       | 46 +++++++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  8 +++++-
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d7f7ab34eeba..42983aadf57f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -150,15 +150,30 @@ static int sched(struct c4iw_dev *dev, struct sk_buff *skb);
 static LIST_HEAD(timeout_list);
 static spinlock_t timeout_lock;
 
+static void deref_cm_id(struct c4iw_ep_common *epc)
+{
+	epc->cm_id->rem_ref(epc->cm_id);
+	epc->cm_id = NULL;
+	set_bit(CM_ID_DEREFED, &epc->history);
+}
+
+static void ref_cm_id(struct c4iw_ep_common *epc)
+{
+	set_bit(CM_ID_REFED, &epc->history);
+	epc->cm_id->add_ref(epc->cm_id);
+}
+
 static void deref_qp(struct c4iw_ep *ep)
 {
 	c4iw_qp_rem_ref(&ep->com.qp->ibqp);
 	clear_bit(QP_REFERENCED, &ep->com.flags);
+	set_bit(QP_DEREFED, &ep->com.history);
 }
 
 static void ref_qp(struct c4iw_ep *ep)
 {
 	set_bit(QP_REFERENCED, &ep->com.flags);
+	set_bit(QP_REFED, &ep->com.history);
 	c4iw_qp_add_ref(&ep->com.qp->ibqp);
 }
 
@@ -1173,8 +1188,7 @@ static void close_complete_upcall(struct c4iw_ep *ep, int status)
 		PDBG("close complete delivered ep %p cm_id %p tid %u\n",
 		     ep, ep->com.cm_id, ep->hwtid);
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
-		ep->com.cm_id->rem_ref(ep->com.cm_id);
-		ep->com.cm_id = NULL;
+		deref_cm_id(&ep->com);
 		set_bit(CLOSE_UPCALL, &ep->com.history);
 	}
 }
@@ -1206,8 +1220,7 @@ static void peer_abort_upcall(struct c4iw_ep *ep)
 		PDBG("abort delivered ep %p cm_id %p tid %u\n", ep,
 		     ep->com.cm_id, ep->hwtid);
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
-		ep->com.cm_id->rem_ref(ep->com.cm_id);
-		ep->com.cm_id = NULL;
+		deref_cm_id(&ep->com);
 		set_bit(ABORT_UPCALL, &ep->com.history);
 	}
 }
@@ -1250,10 +1263,8 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status)
 	set_bit(CONN_RPL_UPCALL, &ep->com.history);
 	ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 
-	if (status < 0) {
-		ep->com.cm_id->rem_ref(ep->com.cm_id);
-		ep->com.cm_id = NULL;
-	}
+	if (status < 0)
+		deref_cm_id(&ep->com);
 }
 
 static int connect_request_upcall(struct c4iw_ep *ep)
@@ -2818,6 +2829,7 @@ static int close_con_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	/* The cm_id may be null if we failed to connect */
 	mutex_lock(&ep->com.mutex);
+	set_bit(CLOSE_CON_RPL, &ep->com.history);
 	switch (ep->com.state) {
 	case CLOSING:
 		__state_set(&ep->com, MORIBUND);
@@ -2998,8 +3010,8 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	PDBG("%s %d ird %d ord %d\n", __func__, __LINE__, ep->ird, ep->ord);
 
-	cm_id->add_ref(cm_id);
 	ep->com.cm_id = cm_id;
+	ref_cm_id(&ep->com);
 	ep->com.qp = qp;
 	ref_qp(ep);
 
@@ -3032,8 +3044,7 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	c4iw_put_ep(&ep->com);
 	return 0;
 err_deref_cm_id:
-	ep->com.cm_id = NULL;
-	cm_id->rem_ref(cm_id);
+	deref_cm_id(&ep->com);
 err_abort:
 	abort = 1;
 err_out:
@@ -3139,9 +3150,9 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (peer2peer && ep->ord == 0)
 		ep->ord = 1;
 
-	cm_id->add_ref(cm_id);
-	ep->com.dev = dev;
 	ep->com.cm_id = cm_id;
+	ref_cm_id(&ep->com);
+	ep->com.dev = dev;
 	ep->com.qp = get_qhp(dev, conn_param->qpn);
 	if (!ep->com.qp) {
 		PDBG("%s qpn 0x%x not found!\n", __func__, conn_param->qpn);
@@ -3248,7 +3259,7 @@ fail2:
 	remove_handle(ep->com.dev, &ep->com.dev->atid_idr, ep->atid);
 	cxgb4_free_atid(ep->com.dev->rdev.lldi.tids, ep->atid);
 fail1:
-	cm_id->rem_ref(cm_id);
+	deref_cm_id(&ep->com);
 	c4iw_put_ep(&ep->com);
 out:
 	return err;
@@ -3342,8 +3353,8 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		goto fail1;
 	}
 	PDBG("%s ep %p\n", __func__, ep);
-	cm_id->add_ref(cm_id);
 	ep->com.cm_id = cm_id;
+	ref_cm_id(&ep->com);
 	ep->com.dev = dev;
 	ep->backlog = backlog;
 	memcpy(&ep->com.local_addr, &cm_id->m_local_addr,
@@ -3383,7 +3394,7 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid,
 			ep->com.local_addr.ss_family);
 fail2:
-	cm_id->rem_ref(cm_id);
+	deref_cm_id(&ep->com);
 	c4iw_put_ep(&ep->com);
 fail1:
 out:
@@ -3422,7 +3433,7 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid,
 			ep->com.local_addr.ss_family);
 done:
-	cm_id->rem_ref(cm_id);
+	deref_cm_id(&ep->com);
 	c4iw_put_ep(&ep->com);
 	return err;
 }
@@ -3497,6 +3508,7 @@ int c4iw_ep_disconnect(struct c4iw_ep *ep, int abrupt, gfp_t gfp)
 			ret = send_halfclose(ep, gfp);
 		}
 		if (ret) {
+			set_bit(EP_DISC_FAIL, &ep->com.history);
 			if (!abrupt) {
 				stop_ep_timer(ep);
 				close_complete_upcall(ep, -EIO);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index df43f871ab61..67710aeeb4f2 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -779,7 +779,13 @@ enum c4iw_ep_history {
 	EP_DISC_ABORT           = 18,
 	CONN_RPL_UPCALL         = 19,
 	ACT_RETRY_NOMEM         = 20,
-	ACT_RETRY_INUSE         = 21
+	ACT_RETRY_INUSE         = 21,
+	CLOSE_CON_RPL		= 22,
+	EP_DISC_FAIL		= 24,
+	QP_REFED		= 25,
+	QP_DEREFED		= 26,
+	CM_ID_REFED		= 27,
+	CM_ID_DEREFED		= 28,
 };
 
 struct c4iw_ep_common {
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
