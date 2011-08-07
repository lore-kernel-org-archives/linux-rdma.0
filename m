From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 7/7] Fix a compiler warning related to NVALGRIND
Date: Sun, 7 Aug 2011 20:05:30 +0200
Message-ID: <201108072005.30807.bvanassche@acm.org>
References: <201108072000.16383.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201108072000.16383.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that compiling with NVALGRIND defined and the latest Valgrind header
files triggers compiler warnings. Recently the Valgrind client request
implementation has been modified in order to not trigger compiler warnings
when building with gcc 4.6. A side effect of that change is that Valgrind
client request macros that return a value have to be cast to void in order
to avoid a compiler warning.

For more information, see also:
* Valgrind manual about VALGRIND_MAKE_MEM_DEFINED (http://valgrind.org/docs/manual/mc-manual.html).
* Valgrind trunk r11755 (http://article.gmane.org/gmane.comp.debugging.valgrind.devel/13489).

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 src/cmd.c     |   42 +++++++++++++++++++++---------------------
 src/ibverbs.h |    2 +-
 src/verbs.c   |    2 +-
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/src/cmd.c b/src/cmd.c
index 39af833..0b00884 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -71,7 +71,7 @@ static int ibv_cmd_get_context_v2(struct ibv_context *context,
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	context->async_fd         = resp->async_fd;
 	context->num_comp_vectors = 1;
@@ -95,7 +95,7 @@ int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	context->async_fd         = resp->async_fd;
 	context->num_comp_vectors = resp->num_comp_vectors;
@@ -115,7 +115,7 @@ int ibv_cmd_query_device(struct ibv_context *context,
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	memset(device_attr->fw_ver, 0, sizeof device_attr->fw_ver);
 	*raw_fw_ver			       = resp.fw_ver;
@@ -175,7 +175,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	port_attr->state      	   = resp.state;
 	port_attr->max_mtu         = resp.max_mtu;
@@ -210,7 +210,7 @@ int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	pd->handle  = resp->pd_handle;
 	pd->context = context;
@@ -249,7 +249,7 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	mr->handle  = resp->mr_handle;
 	mr->lkey    = resp->lkey;
@@ -292,7 +292,7 @@ static int ibv_cmd_create_cq_v2(struct ibv_context *context, int cqe,
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	cq->handle  = resp->cq_handle;
 	cq->cqe     = resp->cqe;
@@ -321,7 +321,7 @@ int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 	if (write(context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	cq->handle  = resp->cq_handle;
 	cq->cqe     = resp->cqe;
@@ -352,7 +352,7 @@ int ibv_cmd_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 		goto out;
 	}
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, rsize);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, rsize);
 
 	for (i = 0; i < resp->count; i++) {
 		wc[i].wr_id 	     = resp->wc[i].wr_id;
@@ -403,7 +403,7 @@ int ibv_cmd_resize_cq(struct ibv_cq *cq, int cqe,
 	if (write(cq->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	cq->cqe = resp->cqe;
 
@@ -438,7 +438,7 @@ int ibv_cmd_destroy_cq(struct ibv_cq *cq)
 	if (write(cq->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	pthread_mutex_lock(&cq->mutex);
 	while (cq->comp_events_completed  != resp.comp_events_reported ||
@@ -464,7 +464,7 @@ int ibv_cmd_create_srq(struct ibv_pd *pd,
 	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	srq->handle  = resp->srq_handle;
 	srq->context = pd->context;
@@ -546,7 +546,7 @@ int ibv_cmd_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr,
 	if (write(srq->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	srq_attr->max_wr    = resp.max_wr;
 	srq_attr->max_sge   = resp.max_sge;
@@ -583,7 +583,7 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq)
 	if (write(srq->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	pthread_mutex_lock(&srq->mutex);
 	while (srq->events_completed != resp.events_reported)
@@ -618,7 +618,7 @@ int ibv_cmd_create_qp(struct ibv_pd *pd,
 	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
+	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
 	qp->handle 		  = resp->qp_handle;
 	qp->qp_num 		  = resp->qpn;
@@ -665,7 +665,7 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	if (write(qp->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	attr->qkey                          = resp.qkey;
 	attr->rq_psn                        = resp.rq_psn;
@@ -886,7 +886,7 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	if (write(ibqp->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		ret = errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	wr_count = resp.bad_wr;
 	if (wr_count) {
@@ -947,7 +947,7 @@ int ibv_cmd_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	if (write(ibqp->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		ret = errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	wr_count = resp.bad_wr;
 	if (wr_count) {
@@ -1008,7 +1008,7 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 	if (write(srq->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		ret = errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	wr_count = resp.bad_wr;
 	if (wr_count) {
@@ -1046,7 +1046,7 @@ int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	ah->handle  = resp.handle;
 	ah->context = pd->context;
@@ -1082,7 +1082,7 @@ int ibv_cmd_destroy_qp(struct ibv_qp *qp)
 	if (write(qp->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
 		return errno;
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	pthread_mutex_lock(&qp->mutex);
 	while (qp->events_completed != resp.events_reported)
diff --git a/src/ibverbs.h b/src/ibverbs.h
index 6a6e3c8..fa6cd41 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -49,7 +49,7 @@
 #endif /* HAVE_VALGRIND_MEMCHECK_H */
 
 #ifndef VALGRIND_MAKE_MEM_DEFINED
-#  define VALGRIND_MAKE_MEM_DEFINED(addr, len)
+#  define VALGRIND_MAKE_MEM_DEFINED(addr, len) 0
 #endif
 
 #define HIDDEN		__attribute__((visibility ("hidden")))
diff --git a/src/verbs.c b/src/verbs.c
index ba3c0a4..8678b32 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -226,7 +226,7 @@ struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context)
 		return NULL;
 	}
 
-	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void)VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	channel->context = context;
 	channel->fd      = resp.fd;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
