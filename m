From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] librdmacm: convert ibv error values to errno
Date: Thu, 22 Jul 2010 21:12:18 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F6@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A732D5F4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The librdmacm documentation (rdma_cm.7 man page) specifies that librdmacm
functions return 0 on success and -1 on error, with errno set correctly.
The libibverbs abstractions simply pass the libibverbs return codes
through to the user.  Since libibverbs may return errno directly through
a given call, convert the return status to use errno where appropriate.

This fixes an issue with rdma_get_send_comp and rdma_get_recv_comp, where
a return value of 1 could indicate both success (1 completed request
returned) and failure (EPERM error).

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_verbs.h |   44 +++++++++++++++++++++++++++-----------------
 src/cma.c                 |    1 +
 2 files changed, 28 insertions(+), 17 deletions(-)
 mode change 100644 => 100755 include/rdma/rdma_verbs.h

diff --git a/include/rdma/rdma_verbs.h b/include/rdma/rdma_verbs.h
old mode 100644
new mode 100755
index 12429a7..d75d906
--- a/include/rdma/rdma_verbs.h
+++ b/include/rdma/rdma_verbs.h
@@ -36,11 +36,21 @@
 #include <assert.h>
 #include <infiniband/verbs.h>
 #include <rdma/rdma_cma.h>
+#include <errno.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
+static inline int rdma_seterrno(int ret)
+{
+	if (ret) {
+		errno = ret;
+		ret = -1;
+	}
+	return ret;
+}
+
 /*
  * Memory registration helpers.
  */
@@ -53,7 +63,7 @@ rdma_reg_msgs(struct rdma_cm_id *id, void *addr, size_t length)
 static inline struct ibv_mr *
 rdma_reg_read(struct rdma_cm_id *id, void *addr, size_t length)
 {
-	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE|
+	return ibv_reg_mr(id->qp->pd, addr, length, IBV_ACCESS_LOCAL_WRITE |
 						    IBV_ACCESS_REMOTE_READ);
 }
 
@@ -67,7 +77,7 @@ rdma_reg_write(struct rdma_cm_id *id, void *addr, size_t length)
 static inline int
 rdma_dereg_mr(struct ibv_mr *mr)
 {
-	return ibv_dereg_mr(mr);
+	return rdma_seterrno(ibv_dereg_mr(mr));
 }
 
 
@@ -86,7 +96,7 @@ rdma_post_recvv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
 	wr.sg_list = sgl;
 	wr.num_sge = nsge;
 
-	return ibv_post_recv(id->qp, &wr, &bad);
+	return rdma_seterrno(ibv_post_recv(id->qp, &wr, &bad));
 }
 
 static inline int
@@ -102,7 +112,7 @@ rdma_post_sendv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
 	wr.opcode = IBV_WR_SEND;
 	wr.send_flags = flags;
 
-	return ibv_post_send(id->qp, &wr, &bad);
+	return rdma_seterrno(ibv_post_send(id->qp, &wr, &bad));
 }
 
 static inline int
@@ -120,7 +130,7 @@ rdma_post_readv(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
 	wr.wr.rdma.remote_addr = remote_addr;
 	wr.wr.rdma.rkey = rkey;
 
-	return ibv_post_send(id->qp, &wr, &bad);
+	return rdma_seterrno(ibv_post_send(id->qp, &wr, &bad));
 }
 
 static inline int
@@ -138,7 +148,7 @@ rdma_post_writev(struct rdma_cm_id *id, void *context, struct ibv_sge *sgl,
 	wr.wr.rdma.remote_addr = remote_addr;
 	wr.wr.rdma.rkey = rkey;
 
-	return ibv_post_send(id->qp, &wr, &bad);
+	return rdma_seterrno(ibv_post_send(id->qp, &wr, &bad));
 }
 
 /*
@@ -221,7 +231,7 @@ rdma_post_ud_send(struct rdma_cm_id *id, void *context, void *addr,
 	wr.wr.ud.remote_qpn = remote_qpn;
 	wr.wr.ud.remote_qkey = RDMA_UDP_QKEY;
 
-	return ibv_post_send(id->qp, &wr, &bad);
+	return rdma_seterrno(ibv_post_send(id->qp, &wr, &bad));
 }
 
 static inline int
@@ -233,22 +243,22 @@ rdma_get_send_comp(struct rdma_cm_id *id, struct ibv_wc *wc)
 
 	ret = ibv_poll_cq(id->send_cq, 1, wc);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = ibv_req_notify_cq(id->send_cq, 0);
 	if (ret)
-		return ret;
+		return rdma_seterrno(ret);
 
 	while (!(ret = ibv_poll_cq(id->send_cq, 1, wc))) {
 		ret = ibv_get_cq_event(id->send_cq_channel, &cq, &context);
 		if (ret)
-			break;
+			return rdma_seterrno(ret);
 
 		assert(cq == id->send_cq && context == id);
 		ibv_ack_cq_events(id->send_cq, 1);
 	}
-
-	return ret;
+out:
+	return (ret < 0) ? rdma_seterrno(ret) : ret;
 }
 
 static inline int
@@ -260,22 +270,22 @@ rdma_get_recv_comp(struct rdma_cm_id *id, struct ibv_wc *wc)
 
 	ret = ibv_poll_cq(id->recv_cq, 1, wc);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = ibv_req_notify_cq(id->recv_cq, 0);
 	if (ret)
-		return ret;
+		return rdma_seterrno(ret);
 
 	while (!(ret = ibv_poll_cq(id->recv_cq, 1, wc))) {
 		ret = ibv_get_cq_event(id->recv_cq_channel, &cq, &context);
 		if (ret)
-			break;
+			return rdma_seterrno(ret);
 
 		assert(cq == id->recv_cq && context == id);
 		ibv_ack_cq_events(id->recv_cq, 1);
 	}
-
-	return ret;
+out:
+	return (ret < 0) ? rdma_seterrno(ret) : ret;
 }
 
 #ifdef __cplusplus
diff --git a/src/cma.c b/src/cma.c
index 7ddccbb..a20e2f5 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -56,6 +56,7 @@
 #include <infiniband/marshall.h>
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_cma_abi.h>
+#include <rdma/rdma_verbs.h>
 #include <infiniband/ib.h>
 
 #define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
