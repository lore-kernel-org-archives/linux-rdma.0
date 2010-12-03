From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: cma: disconnect can block for excessive times
 waiting for rdma_cm DREP timeout
Date: Fri, 3 Dec 2010 15:33:04 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011C4D94F6@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_cm uses the same timeout values for connect and disconnect
request/reply. Disconnect abrupt option allows DAT consumers to
specify a prompt disconnect with immediate event. If the remote
node goes down or is non-responsive a CM disconnect event could
take minutes. Add a time limit waiting for event and move EP to
disconnected state to prevent callback from issuing duplicate
disconnect event via callback. The EP to CM linking will
cleanup/cancel any pending events before destroying cm_id.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 1eb7aed..ff48999 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -623,6 +623,7 @@ DAT_RETURN
 dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 {
 	struct dapl_cm_id *conn = dapl_get_cm_from_ep(ep_ptr);
+	int drep_time = 25;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " disconnect(ep %p, conn %p, id %d flags %x)\n",
@@ -636,13 +637,29 @@ dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 
 	/* ABRUPT close, wait for callback and DISCONNECTED state */
 	if (close_flags == DAT_CLOSE_ABRUPT_FLAG) {
+		DAPL_EVD *evd = NULL;
+		DAT_EVENT_NUMBER num = DAT_CONNECTION_EVENT_DISCONNECTED;
+
 		dapl_os_lock(&ep_ptr->header.lock);
-		while (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
+		/* limit DREP waiting, other side could be down */
+		while (--drep_time && ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
 			dapl_os_unlock(&ep_ptr->header.lock);
 			dapl_os_sleep_usec(10000);
 			dapl_os_lock(&ep_ptr->header.lock);
 		}
+		if (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
+			dapl_log(DAPL_DBG_TYPE_WARN,
+				 " WARNING: disconnect(ep %p, conn %p, id %d) timed out\n",
+				 ep_ptr, conn, (conn ? conn->cm_id : 0));
+			ep_ptr->param.ep_state = DAT_EP_STATE_DISCONNECTED;
+			evd = (DAPL_EVD *)ep_ptr->param.connect_evd_handle;
+		}
 		dapl_os_unlock(&ep_ptr->header.lock);
+
+		if (evd) {
+			dapl_sp_remove_ep(ep_ptr);
+			dapls_evd_post_connection_event(evd, num, ep_ptr, 0, 0);
+		}
 	}
 
 	/* 
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
