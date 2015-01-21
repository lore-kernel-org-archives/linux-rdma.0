From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 12/20] xprtrdma: Take struct ib_qp_attr and
 ib_qp_init_attr off the stack
Date: Wed, 21 Jan 2015 11:03:35 -0500
Message-ID: <20150121160335.17297.28399.stgit@manet.1015granger.net>
References: <20150121155303.17297.47423.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150121155303.17297.47423.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reduce stack footprint of the connection upcall handler function.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c     |   15 ++++++++-------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 ++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 123bb04..958b372 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -425,8 +425,8 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	struct sockaddr_in *addr = (struct sockaddr_in *) &ep->rep_remote_addr;
 #endif
-	struct ib_qp_attr attr;
-	struct ib_qp_init_attr iattr;
+	struct ib_qp_attr *attr = &ia->ri_qp_attr;
+	struct ib_qp_init_attr *iattr = &ia->ri_qp_init_attr;
 	int connstate = 0;
 
 	switch (event->event) {
@@ -449,12 +449,13 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		connstate = 1;
-		ib_query_qp(ia->ri_id->qp, &attr,
-			IB_QP_MAX_QP_RD_ATOMIC | IB_QP_MAX_DEST_RD_ATOMIC,
-			&iattr);
+		ib_query_qp(ia->ri_id->qp, attr,
+			    IB_QP_MAX_QP_RD_ATOMIC | IB_QP_MAX_DEST_RD_ATOMIC,
+			    iattr);
 		dprintk("RPC:       %s: %d responder resources"
 			" (%d initiator)\n",
-			__func__, attr.max_dest_rd_atomic, attr.max_rd_atomic);
+			__func__, attr->max_dest_rd_atomic,
+			attr->max_rd_atomic);
 		goto connected;
 	case RDMA_CM_EVENT_CONNECT_ERROR:
 		connstate = -ENOTCONN;
@@ -487,7 +488,7 @@ connected:
 
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 	if (connstate == 1) {
-		int ird = attr.max_dest_rd_atomic;
+		int ird = attr->max_dest_rd_atomic;
 		int tird = ep->rep_remote_cma.responder_resources;
 		printk(KERN_INFO "rpcrdma: connection to %pI4:%u "
 			"on %s, memreg %d slots %d ird %d%s\n",
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index ec596ce..2b4e778 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -71,6 +71,8 @@ struct rpcrdma_ia {
 	enum rpcrdma_memreg	ri_memreg_strategy;
 	unsigned int		ri_max_frmr_depth;
 	struct ib_device_attr	ri_devattr;
+	struct ib_qp_attr	ri_qp_attr;
+	struct ib_qp_init_attr	ri_qp_init_attr;
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
