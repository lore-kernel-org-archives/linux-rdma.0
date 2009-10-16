From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/11] ucm, scm, cma: Fix CNO support on DTO type EVD's
Date: Fri, 16 Oct 2009 16:52:57 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CD0@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


EVD wait_object should be used for CNO processing
and not the direct CQ event channels. Add proper
checking for DTO type EVD's with CNO at wait
and wakeup.

UCM missing support for collective EVD's under a
CNO. Add support to create common channel for
collective EVD's during device open. Add support
in cm_thread to check this channel. Also,
during disconnect, move QP to error to properly
flush queue instead of moving to reset and init.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/cq.c        |    6 ++++-
 dapl/openib_ucm/cm.c           |   18 ++++++++++---
 dapl/openib_ucm/dapl_ib_util.h |    1 +
 dapl/openib_ucm/device.c       |   52 +++++++++++++++++++++++++++++++++++++++-
 dapl/udapl/dapl_evd_wait.c     |    3 +-
 5 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/dapl/openib_common/cq.c b/dapl/openib_common/cq.c
index 16d4f18..c36a766 100644
--- a/dapl/openib_common/cq.c
+++ b/dapl/openib_common/cq.c
@@ -259,7 +259,11 @@ dapls_evd_dto_wakeup(IN DAPL_EVD * evd_ptr)
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL,
 		     " cq_object_wakeup: evd=%p\n", evd_ptr);
 
-	/* no wake up mechanism */
+	/*  EVD with CNO; waiting on OS wait object */
+	if (evd_ptr->cno_ptr)
+		dapl_os_wait_object_wakeup(&evd_ptr->wait_object);
+
+	/* otherwise, no wake up mechanism */
 	return DAT_SUCCESS;
 }
 
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 29f87b5..7ce3aab 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1510,10 +1510,10 @@ dapls_ib_disconnect(IN DAPL_EP *ep, IN DAT_CLOSE_FLAGS close_flags)
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
 		     "dapls_ib_disconnect(ep_handle %p ....)\n", ep);
 
-	/* reinit to modify QP state, if not UD */
-	if (ep->qp_handle->qp_type != IBV_QPT_UD)
-		dapls_ib_reinit_ep(ep);
-
+	/* move to err state to flush, if not UD */
+	if (ep->qp_handle->qp_type != IBV_QPT_UD) 
+		dapls_modify_qp_state(ep->qp_handle, IBV_QPS_ERR,0,0,0);
+	
 	if (ep->cm_handle == NULL ||
 	    ep->param.ep_state == DAT_EP_STATE_DISCONNECTED)
 		return DAT_SUCCESS;
@@ -1957,6 +1957,7 @@ void cm_thread(void *arg)
 		CompSetZero(&hca->ib_trans.signal.set);
 		CompSetAdd(&hca->ib_hca_handle->channel, &hca->ib_trans.signal.set);
 		CompSetAdd(&hca->ib_trans.rch->comp_channel, &hca->ib_trans.signal.set);
+		CompSetAdd(&hca->ib_cq->comp_channel, &hca->ib_trans.signal.set);
 
 		next = dapl_llist_is_empty(&hca->ib_trans.list) ? NULL :
 			dapl_llist_peek_head(&hca->ib_trans.list);
@@ -1982,12 +1983,16 @@ void cm_thread(void *arg)
 
 		hca->ib_hca_handle->channel.Milliseconds = time_ms;
 		hca->ib_trans.rch->comp_channel.Milliseconds = time_ms;
+		hca->ib_trans.ib_cq->comp_channel.Milliseconds = time_ms;
 		CompSetPoll(&hca->ib_trans.signal.set, time_ms);
 
 		hca->ib_hca_handle->channel.Milliseconds = 0;
 		hca->ib_trans.rch->comp_channel.Milliseconds = 0;
+		hca->ib_trans.ib_cq->comp_channel.Milliseconds = 0;
+
 		ucm_recv(&hca->ib_trans);
 		ucm_async_event(hca);
+		dapli_cq_event_cb(&hca->ib_trans);
 	}
 
 	dapl_os_unlock(&hca->ib_trans.lock);
@@ -2019,6 +2024,7 @@ void cm_thread(void *arg)
 		dapl_fd_set(hca->ib_trans.signal.scm[0], set, DAPL_FD_READ);	
 		dapl_fd_set(hca->ib_hca_handle->async_fd, set, DAPL_FD_READ);
 		dapl_fd_set(hca->ib_trans.rch->fd, set, DAPL_FD_READ);
+		dapl_fd_set(hca->ib_trans.ib_cq->fd, set, DAPL_FD_READ);
 		
 		if (!dapl_llist_is_empty(&hca->ib_trans.list))
 			next = dapl_llist_peek_head(&hca->ib_trans.list);
@@ -2061,6 +2067,10 @@ void cm_thread(void *arg)
 			      DAPL_FD_READ) == DAPL_FD_READ) {
 			ucm_async_event(hca);
 		}
+		if (dapl_poll(hca->ib_trans.ib_cq->fd, 
+			      DAPL_FD_READ) == DAPL_FD_READ) {
+			dapli_cq_event_cb(&hca->ib_trans);
+		}
 		while (dapl_poll(hca->ib_trans.signal.scm[0], 
 				 DAPL_FD_READ) == DAPL_FD_READ) {
 			recv(hca->ib_trans.signal.scm[0], rbuf, 2, 0);
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index eef6384..27ff8dd 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -115,6 +115,7 @@ typedef struct _ib_hca_transport
 /* prototypes */
 void cm_thread(void *arg);
 void ucm_async_event(struct dapl_hca *hca);
+void dapli_cq_event_cb(struct _ib_hca_transport *tp);
 dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep);
 void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep);
 void dapls_print_cm_list(IN DAPL_IA *ia_ptr);
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 65f5f9b..077446b 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -37,6 +37,8 @@ static void ucm_service_destroy(IN DAPL_HCA *hca);
 static int  ucm_service_create(IN DAPL_HCA *hca);
 
 #if defined (_WIN32)
+#include "..\..\..\..\..\etc\user\comp_channel.cpp"
+#include <rdma\winverbs.h>
 
 static int32_t create_os_signal(IN DAPL_HCA * hca_ptr)
 {
@@ -48,6 +50,18 @@ static void destroy_os_signal(IN DAPL_HCA * hca_ptr)
 	CompSetCleanup(&hca_ptr->ib_trans.signal.set);
 }
 
+static int dapls_config_verbs(struct ibv_context *verbs)
+{
+	verbs->channel.Milliseconds = 0;
+	return 0;
+}
+
+static int dapls_config_comp_channel(struct ibv_comp_channel *channel)
+{
+	channel->comp_channel.Milliseconds = 0;
+	return 0;
+}
+
 #else // _WIN32
 
 static int32_t create_os_signal(IN DAPL_HCA * hca_ptr)
@@ -105,6 +119,31 @@ static void destroy_os_signal(IN DAPL_HCA * hca_ptr)
 	closesocket(hca_ptr->ib_trans.signal.scm[1]);
 }
 
+static int dapls_config_fd(int fd)
+{
+	int opts;
+
+	opts = fcntl(fd, F_GETFL);
+	if (opts < 0 || fcntl(fd, F_SETFL, opts | O_NONBLOCK) < 0) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 " dapls_config_fd: fcntl on fd %d ERR %d %s\n",
+			 fd, opts, strerror(errno));
+		return errno;
+	}
+
+	return 0;
+}
+
+static int dapls_config_verbs(struct ibv_context *verbs)
+{
+	return dapls_config_fd(verbs->async_fd);
+}
+
+static int dapls_config_comp_channel(struct ibv_comp_channel *channel)
+{
+	return dapls_config_fd(channel->fd);
+}
+
 #endif
 
 /*
@@ -187,6 +226,7 @@ found:
 		goto err;
 	}
 	hca_ptr->ib_trans.ib_ctx = hca_ptr->ib_hca_handle;
+	dapls_config_verbs(hca_ptr->ib_hca_handle);
 	
 	/* get lid for this hca-port, network order */
 	if (ibv_query_port(hca_ptr->ib_hca_handle,
@@ -243,7 +283,17 @@ found:
 
 	if ((dapl_os_lock_init(&hca_ptr->ib_trans.plock)) != DAT_SUCCESS)
 		goto err;
-	
+
+	/* EVD events without direct CQ channels, CNO support */
+	hca_ptr->ib_trans.ib_cq =
+	    ibv_create_comp_channel(hca_ptr->ib_hca_handle);
+	if (hca_ptr->ib_trans.ib_cq == NULL) {
+		dapl_log(DAPL_DBG_TYPE_ERR,
+			 " open_hca: ibv_create_comp_channel ERR %s\n",
+			 strerror(errno));
+		goto bail;
+	}
+	dapls_config_comp_channel(hca_ptr->ib_trans.ib_cq);
 
 	/* initialize CM and listen lists on this HCA uCM QP */
 	dapl_llist_init_head(&hca_ptr->ib_trans.list);
diff --git a/dapl/udapl/dapl_evd_wait.c b/dapl/udapl/dapl_evd_wait.c
index 2e501ae..79afb0d 100644
--- a/dapl/udapl/dapl_evd_wait.c
+++ b/dapl/udapl/dapl_evd_wait.c
@@ -215,7 +215,8 @@ DAT_RETURN DAT_API dapl_evd_wait(IN DAT_EVD_HANDLE evd_handle,
 		DAPL_CNTR(evd_ptr, DCNT_EVD_WAIT_BLOCKED);
 		dapl_os_unlock(&evd_ptr->header.lock);
 
-		if (evd_ptr->evd_flags & (DAT_EVD_DTO_FLAG | DAT_EVD_RMR_BIND_FLAG)) {
+		if ((!evd_ptr->cno_ptr) && 
+		    (evd_ptr->evd_flags & (DAT_EVD_DTO_FLAG | DAT_EVD_RMR_BIND_FLAG))) {
 			dat_status = dapls_evd_dto_wait(evd_ptr, time_out);
 		} else {
 			dat_status = dapl_os_wait_object_wait(&evd_ptr->wait_object, time_out);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
