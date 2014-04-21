From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 14/17] xprtrmda: Reduce lock contention in completion
	handlers
Date: Mon, 21 Apr 2014 18:02:50 -0400
Message-ID: <20140421220250.12569.84913.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Skip the ib_poll_cq() after re-arming, if the provider knows there
are no additional items waiting. (Have a look at commit ed23a727 for
more details).

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/verbs.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ce7b45f..81daf2b 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -192,8 +192,11 @@ rpcrdma_sendcq_upcall(struct ib_cq *cq, void *cq_context)
 		return;
 	}
 
-	rc = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	if (rc) {
+	rc = ib_req_notify_cq(cq,
+			IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+	if (rc == 0)
+		return;
+	if (rc < 0) {
 		dprintk("RPC:       %s: ib_req_notify_cq failed: %i\n",
 			__func__, rc);
 		return;
@@ -272,8 +275,11 @@ rpcrdma_recvcq_upcall(struct ib_cq *cq, void *cq_context)
 		return;
 	}
 
-	rc = ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
-	if (rc) {
+	rc = ib_req_notify_cq(cq,
+			IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+	if (rc == 0)
+		return;
+	if (rc < 0) {
 		dprintk("RPC:       %s: ib_req_notify_cq failed: %i\n",
 			__func__, rc);
 		return;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
