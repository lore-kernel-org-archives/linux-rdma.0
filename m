From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/15] uDAPL v2.0 ucm: UD send failures at scale, ucm_send
 ERR: get_smsg(hd=149,tl=150)
Date: Mon, 23 Apr 2012 20:01:01 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F948120272@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Full sendq should retry polling completions instead of failing.
When sendq is full and all requests are pending the get send message
code should retry polling for completions and not return error on first
empty CQ attempt. Give HCA a chance to complete some batched requests.
Also, clean up the send message error logging.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 39ef28d..6b5867a 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -234,38 +234,42 @@ static void ucm_check_timers(dp_ib_cm_handle_t cm, int *timer)
 static ib_cm_msg_t *ucm_get_smsg(ib_hca_transport_t *tp)
 {
 	ib_cm_msg_t *msg = NULL; 
-	int ret, polled = 0, hd = tp->s_hd;
+	int ret, polled = 1, hd = tp->s_hd;
 
 	hd++;
 
 	if (hd == tp->qpe)
 		hd = 0;
 retry:
-	if (hd == tp->s_tl)
+	if (hd == tp->s_tl) {
 		msg = NULL;
+		if (polled % 1000000 == 0)
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				 " ucm_get_smsg: FULLq hd %d == tl %d,"
+				 " completions stalled, polls=%d\n",
+				 hd, tp->s_tl, polled);
+	}
 	else {
 		msg = &tp->sbuf[hd];
 		tp->s_hd = hd; /* new hd */
 	}
 
 	/* if empty, process some completions */
-	if ((msg == NULL) && (!polled)) {
+	if (msg == NULL) {
 		struct ibv_wc wc;
 
 		/* process completions, based on UCM_TX_BURST */
 		ret = ibv_poll_cq(tp->scq, 1, &wc);
 		if (ret < 0) {
 			dapl_log(DAPL_DBG_TYPE_WARN,
-				" get_smsg: cq %p %s\n", 
+				" get_smsg: cq %p %s\n",
 				tp->scq, strerror(errno));
+			return NULL;
 		}
 		/* free up completed sends, update tail */
-		if (ret > 0) {
+		if (ret > 0)
 			tp->s_tl = (int)wc.wr_id;
-			dapl_log(DAPL_DBG_TYPE_CM,
-				" get_smsg: wr_cmp (%d) s_tl=%d\n", 
-				wc.status, tp->s_tl);
-		}
+
 		polled++;
 		goto retry;
 	}
@@ -1000,8 +1004,8 @@ dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm)
 
 bail:
 	dapl_log(DAPL_DBG_TYPE_WARN, 
-		 " connect: ERR %s -> cm_lid %x cm_qpn %x r_psp %x p_sz=%d\n",
-		 strerror(errno), htons(cm->msg.daddr.ib.lid), 
+		 " connect: snd ERR -> cm_lid %x cm_qpn %x r_psp %x p_sz=%d\n",
+		 htons(cm->msg.daddr.ib.lid),
 		 htonl(cm->msg.dqpn), htons(cm->msg.dport), 
 		 htons(cm->msg.p_size));
 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
