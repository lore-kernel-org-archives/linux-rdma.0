From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 01/13] xprtrdma: Cancel refresh worker during buffer
 shutdown
Date: Tue, 11 Apr 2017 13:22:29 -0400
Message-ID: <20170411172229.11300.52129.stgit@manet.1015granger.net>
References: <20170411171820.11300.55637.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170411171820.11300.55637.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Trying to create MRs while the transport is being torn down can
cause a crash.

Fixes: e2ac236c0b65 ("xprtrdma: Allocate MRs on demand")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 3b332b3..2e4fc1e 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1037,6 +1037,7 @@ struct rpcrdma_rep *
 rpcrdma_buffer_destroy(struct rpcrdma_buffer *buf)
 {
 	cancel_delayed_work_sync(&buf->rb_recovery_worker);
+	cancel_delayed_work_sync(&buf->rb_refresh_worker);
 
 	while (!list_empty(&buf->rb_recv_bufs)) {
 		struct rpcrdma_rep *rep;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
