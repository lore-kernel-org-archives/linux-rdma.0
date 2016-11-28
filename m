From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 2/2] IB/rxe: Hold refs when running tasklets
Date: Mon, 28 Nov 2016 09:37:24 -0500
Message-ID: <1480343844-8381-3-git-send-email-andrew.boyer@dell.com>
References: <1480343844-8381-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480343844-8381-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It might be possible for all of a QP's references to be dropped
while one of that QP's tasklets is running.

For example, the completer might run during QP destroy.
If qp->valid is false, it will drop all of the packets on
the resp_pkts list, potentially removing the last reference.
Then it tries to advance the SQ consumer pointer. If the
SQ's buffer has already been destroyed, the system will
panic.

To be safe, hold a reference on the QP for the duration
of each tasklet.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 4 ++++
 drivers/infiniband/sw/rxe/rxe_req.c  | 4 ++++
 drivers/infiniband/sw/rxe/rxe_resp.c | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 6c5e29d..3687fcd 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -510,6 +510,8 @@ int rxe_completer(void *arg)
 	struct rxe_pkt_info *pkt = NULL;
 	enum comp_state state;
 
+	rxe_add_ref(qp);
+
 	if (!qp->valid) {
 		while ((skb = skb_dequeue(&qp->resp_pkts))) {
 			rxe_drop_ref(qp);
@@ -739,11 +741,13 @@ int rxe_completer(void *arg)
 	/* we come here if we are done with processing and want the task to
 	 * exit from the loop calling us
 	 */
+	rxe_drop_ref(qp);
 	return -EAGAIN;
 
 done:
 	/* we come here if we have processed a packet we want the task to call
 	 * us again to see if there is anything else to do
 	 */
+	rxe_drop_ref(qp);
 	return 0;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 22bd963..035cb90 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -596,6 +596,8 @@ int rxe_requester(void *arg)
 	struct rxe_qp rollback_qp;
 	struct rxe_send_wqe rollback_wqe;
 
+	rxe_add_ref(qp);
+
 next_wqe:
 	if (unlikely(!qp->valid || qp->req.state == QP_STATE_ERROR))
 		goto exit;
@@ -756,8 +758,10 @@ int rxe_requester(void *arg)
 	 */
 	wqe->wr.send_flags |= IB_SEND_SIGNALED;
 	__rxe_do_task(&qp->comp.task);
+	rxe_drop_ref(qp);
 	return -EAGAIN;
 
 exit:
+	rxe_drop_ref(qp);
 	return -EAGAIN;
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index dd3d88a..337a1cb 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1198,6 +1198,8 @@ int rxe_responder(void *arg)
 	struct rxe_pkt_info *pkt = NULL;
 	int ret = 0;
 
+	rxe_add_ref(qp);
+
 	qp->resp.aeth_syndrome = AETH_ACK_UNLIMITED;
 
 	if (!qp->valid) {
@@ -1386,5 +1388,6 @@ int rxe_responder(void *arg)
 exit:
 	ret = -EAGAIN;
 done:
+	rxe_drop_ref(qp);
 	return ret;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
