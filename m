From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 21/21] xprtrdma: Handle additional connection events
Date: Tue, 15 Jul 2014 10:23:12 -0400
Message-ID: <20140715142311.8908.23658.stgit@manet.1015granger.net>
References: <20140715142020.8908.80969.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715142020.8908.80969.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 38ca83a5 added RDMA_CM_EVENT_TIMEWAIT_EXIT. But that status
is relevant only for consumers that re-use their QPs on new
connections. xprtrdma creates a fresh QP on reconnection, so that
event should be explicitly ignored.

Squelch the alarming "unexpected CM event" message.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 721a6fd..6ead5df 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -326,8 +326,16 @@ static const char * const conn[] = {
 	"rejected",
 	"established",
 	"disconnected",
-	"device removal"
+	"device removal",
+	"multicast join",
+	"multicast error",
+	"address change",
+	"timewait exit",
 };
+
+#define CONNECTION_MSG(status)						\
+	((status) < ARRAY_SIZE(conn) ?					\
+		conn[(status)] : "unrecognized connection error")
 #endif
 
 static int
@@ -385,23 +393,18 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 		connstate = -ENODEV;
 connected:
-		dprintk("RPC:       %s: %s: %pI4:%u (ep 0x%p event 0x%x)\n",
-			__func__,
-			(event->event <= 11) ? conn[event->event] :
-						"unknown connection error",
-			&addr->sin_addr.s_addr,
-			ntohs(addr->sin_port),
-			ep, event->event);
 		atomic_set(&rpcx_to_rdmax(ep->rep_xprt)->rx_buf.rb_credits, 1);
 		dprintk("RPC:       %s: %sconnected\n",
 					__func__, connstate > 0 ? "" : "dis");
 		ep->rep_connected = connstate;
 		ep->rep_func(ep);
 		wake_up_all(&ep->rep_connect_wait);
-		break;
+		/*FALLTHROUGH*/
 	default:
-		dprintk("RPC:       %s: unexpected CM event %d\n",
-			__func__, event->event);
+		dprintk("RPC:       %s: %pI4:%u (ep 0x%p): %s\n",
+			__func__, &addr->sin_addr.s_addr,
+			ntohs(addr->sin_port), ep,
+			CONNECTION_MSG(event->event));
 		break;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
