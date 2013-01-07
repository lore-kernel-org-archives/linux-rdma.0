From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 04/11] RDMA/cxgb4: keep qp referenced until TID released.
Date: Mon,  7 Jan 2013 18:41:53 +0530
Message-ID: <1357564320-15022-5-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The driver is currently releasing the last ref on the QP too early.
This can cause bus errors due to HW still fetching WRs from the hw queue.
The fix is to keep a qp ref until we release the HW TID.

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c       |   20 ++++++++++++++++----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 31d1fac..ebcdb3f 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -143,6 +143,18 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status);
 static LIST_HEAD(timeout_list);
 static spinlock_t timeout_lock;
 
+static void deref_qp(struct c4iw_ep *ep)
+{
+	c4iw_qp_rem_ref(&ep->com.qp->ibqp);
+	clear_bit(QP_REFERENCED, &ep->com.flags);
+}
+
+static void ref_qp(struct c4iw_ep *ep)
+{
+	set_bit(QP_REFERENCED, &ep->com.flags);
+	c4iw_qp_add_ref(&ep->com.qp->ibqp);
+}
+
 static void start_ep_timer(struct c4iw_ep *ep)
 {
 	PDBG("%s ep %p\n", __func__, ep);
@@ -271,6 +283,8 @@ void _c4iw_free_ep(struct kref *kref)
 
 	ep = container_of(kref, struct c4iw_ep, com.kref);
 	PDBG("%s ep %p state %s\n", __func__, ep, states[state_read(&ep->com)]);
+	if (test_bit(QP_REFERENCED, &ep->com.flags))
+		deref_qp(ep);
 	if (test_bit(RELEASE_RESOURCES, &ep->com.flags)) {
 		cxgb4_remove_tid(ep->com.dev->rdev.lldi.tids, 0, ep->hwtid);
 		dst_release(ep->dst);
@@ -863,7 +877,6 @@ static void close_complete_upcall(struct c4iw_ep *ep)
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 		ep->com.cm_id->rem_ref(ep->com.cm_id);
 		ep->com.cm_id = NULL;
-		ep->com.qp = NULL;
 		set_bit(CLOSE_UPCALL, &ep->com.history);
 	}
 }
@@ -906,7 +919,6 @@ static void peer_abort_upcall(struct c4iw_ep *ep)
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 		ep->com.cm_id->rem_ref(ep->com.cm_id);
 		ep->com.cm_id = NULL;
-		ep->com.qp = NULL;
 		set_bit(ABORT_UPCALL, &ep->com.history);
 	}
 }
@@ -946,7 +958,6 @@ static void connect_reply_upcall(struct c4iw_ep *ep, int status)
 	if (status < 0) {
 		ep->com.cm_id->rem_ref(ep->com.cm_id);
 		ep->com.cm_id = NULL;
-		ep->com.qp = NULL;
 	}
 }
 
@@ -2434,6 +2445,7 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_id->add_ref(cm_id);
 	ep->com.cm_id = cm_id;
 	ep->com.qp = qp;
+	ref_qp(ep);
 
 	/* bind QP to EP and move to RTS */
 	attrs.mpa_attr = ep->mpa_attr;
@@ -2464,7 +2476,6 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	return 0;
 err1:
 	ep->com.cm_id = NULL;
-	ep->com.qp = NULL;
 	cm_id->rem_ref(cm_id);
 err:
 	c4iw_put_ep(&ep->com);
@@ -2505,6 +2516,7 @@ int c4iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	ep->com.cm_id = cm_id;
 	ep->com.qp = get_qhp(dev, conn_param->qpn);
 	BUG_ON(!ep->com.qp);
+	ref_qp(ep);
 	PDBG("%s qpn 0x%x qp %p cm_id %p\n", __func__, conn_param->qpn,
 	     ep->com.qp, cm_id);
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 9c1644f..0aaaa0e 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -716,6 +716,7 @@ enum c4iw_ep_flags {
 	ABORT_REQ_IN_PROGRESS	= 1,
 	RELEASE_RESOURCES	= 2,
 	CLOSE_SENT		= 3,
+	QP_REFERENCED           = 5,
 };
 
 enum c4iw_ep_history {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
