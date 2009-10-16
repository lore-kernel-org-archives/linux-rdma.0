From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/11] ucm: create build environment for WinOF
Date: Fri, 16 Oct 2009 16:51:12 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835ECA1CC8@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 dapl/openib_ucm/SOURCES                   |   18 ++------
 dapl/openib_ucm/cm.c                      |   48 ++++++++-------------
 dapl/openib_ucm/dapl_ib_util.h            |    2 +-
 dapl/openib_ucm/device.c                  |   66 +++++++++++++----------------
 dapl/openib_ucm/linux/openib_osd.h        |   10 ++++
 dapl/openib_ucm/makefile                  |    7 +++
 dapl/openib_ucm/udapl.rc                  |    8 ++--
 dapl/openib_ucm/udapl_ofa_ucm_exports.src |   14 ++++++
 dapl/openib_ucm/windows/openib_osd.h      |   11 +++++
 9 files changed, 100 insertions(+), 84 deletions(-)
 create mode 100644 dapl/openib_ucm/makefile
 create mode 100644 dapl/openib_ucm/udapl_ofa_ucm_exports.src

diff --git a/dapl/openib_ucm/SOURCES b/dapl/openib_ucm/SOURCES
index dfe956f..7eecf48 100644
--- a/dapl/openib_ucm/SOURCES
+++ b/dapl/openib_ucm/SOURCES
@@ -16,22 +16,14 @@ DLLDEF=$(OBJ_PATH)\$O\udapl_ofa_ucm_exports.def
 
 USE_MSVCRT = 1
 
-SOURCES = \
-	udapl.rc \
-	..\dapl_common_src.c	\
-	..\dapl_udapl_src.c		\
-	dapl_ib_cq.c			\
-	dapl_ib_extensions.c	\
-	dapl_ib_mem.c			\
-	dapl_ib_qp.c			\
-	dapl_ib_util.c			\
-	dapl_ib_cm.c
-
-INCLUDES = ..\include;..\common;windows;..\..\dat\include;\
+SOURCES = udapl.rc ..\dapl_common_src.c ..\dapl_udapl_src.c ..\openib_common.c \
+	device.c cm.c
+
+INCLUDES = ..\include;..\openib_common\;..\common;windows;..\..\dat\include;\
 		   ..\..\dat\udat\windows;..\udapl\windows;\
 		   ..\..\..\..\inc;..\..\..\..\inc\user;..\..\..\libibverbs\include
 
-DAPL_OPTS = -DEXPORT_DAPL_SYMBOLS -DDAT_EXTENSIONS -DSOCK_CM -DOPENIB -DCQ_WAIT_OBJECT
+DAPL_OPTS = -DEXPORT_DAPL_SYMBOLS -DDAT_EXTENSIONS -DOPENIB -DCQ_WAIT_OBJECT
 
 USER_C_FLAGS = $(USER_C_FLAGS) $(DAPL_OPTS)
 
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 41a7c9e..9d702a8 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -115,7 +115,6 @@ static int ucm_send(ib_hca_transport_t *tp, ib_cm_msg_t *msg, DAT_PVOID p_data,
 static void ucm_disconnect_final(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm);
 DAT_RETURN dapli_cm_connect(DAPL_EP *ep, dp_ib_cm_handle_t cm);
-static void dapls_thread_signal(struct dapl_hca *hca);
 
 #define UCM_SND_BURST	50	
 
@@ -675,7 +674,7 @@ static void ucm_ud_free(DAPL_EP *ep)
 
 	/* wakeup work thread if necessary */
 	if (hca)
-		dapls_thread_signal(hca);
+		dapls_thread_signal(&tp->signal);
 }
 
 /* mark for destroy, remove all references, schedule cleanup */
@@ -719,7 +718,7 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
 	dapl_os_unlock(&cm->lock);
 
 	/* wakeup work thread */
-	dapls_thread_signal(cm->hca);
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
 }
 
 /* ACTIVE/PASSIVE: queue up connection object on CM list */
@@ -731,7 +730,7 @@ static void ucm_queue_conn(dp_ib_cm_handle_t cm)
 	dapl_llist_add_tail(&cm->hca->ib_trans.list,
 			    (DAPL_LLIST_ENTRY *)&cm->entry, cm);
 	dapl_os_unlock(&cm->hca->ib_trans.lock);
-	dapls_thread_signal(cm->hca);
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
 }
 
 /* PASSIVE: queue up listen object on listen list */
@@ -790,7 +789,7 @@ DAT_RETURN dapli_cm_disconnect(dp_ib_cm_handle_t cm)
 		cm->msg.op = htons(DCM_DREQ);
 		cm->retries = 1;
 		finalize = 0; /* wait for DREP, wakeup timer thread */
-		dapls_thread_signal(cm->hca);
+		dapls_thread_signal(&cm->hca->ib_trans.signal);
 		break;
 	case DCM_DISC_PENDING:
 		/* DREQ timeout, resend until retries exhausted */
@@ -1272,6 +1271,10 @@ static int ucm_reply(dp_ib_cm_handle_t cm)
 			 htonl(cm->msg.daddr.ib.qpn));
 			
 		dapl_os_unlock(&cm->lock);
+#ifdef DAPL_COUNTERS
+		if (g_dapl_dbg_type & DAPL_DBG_TYPE_CM_LIST)
+			dapls_print_cm_list(dapl_llist_peek_head(&cm->hca->ia_list_head));
+#endif
 #ifdef DAT_EXTENSIONS
 		if (cm->msg.saddr.ib.qp_type == IBV_QPT_UD) {
 			DAT_IB_EXTENSION_EVENT_DATA xevent;
@@ -1406,7 +1409,7 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 		goto bail;
 	
 	dapl_dbg_log(DAPL_DBG_TYPE_CM, " PASSIVE: accepted!\n");
-	dapls_thread_signal(cm->hca);
+	dapls_thread_signal(&cm->hca->ib_trans.signal);
 	return DAT_SUCCESS;
 bail:
 	if (cm->msg.saddr.ib.qp_type != IBV_QPT_UD)
@@ -1921,31 +1924,24 @@ ib_cm_events_t dapls_ib_get_cm_event(IN DAT_EVENT_NUMBER dat_event_num)
 }
 
 #if defined(_WIN32) || defined(_WIN64)
-static void dapls_thread_signal(struct dapl_hca *hca)
-{
-//	CompSetCancel(&ufds);
-}
 
 void cm_thread(void *arg)
 {
 	struct dapl_hca *hca = arg;
 	dp_ib_cm_handle_t cm, next;
-	COMP_SET ufds;
 	DWORD time_ms;
 
-	CompSetInit(&ufds);
-
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread: ENTER hca %p\n", hca);
 	dapl_os_lock(&hca->ib_trans.lock);
 	for (hca->ib_trans.cm_state = IB_THREAD_RUN;
-	     hca->ib_trans.cm_state == IB_THREAD_RUN &&
-	     dapl_llist_is_empty(&hca->ib_trans.list);
+	     hca->ib_trans.cm_state == IB_THREAD_RUN ||
+	     !dapl_llist_is_empty(&hca->ib_trans.list);
 	     dapl_os_lock(&hca->ib_trans.lock)) {
 
 		time_ms = INFINITE;
-		CompSetZero(&ufds);
-		CompSetAdd(&hca->ib_hca_handle->channel, &ufds);
-		CompSetAdd(&hca->ib_trans.rch->comp_channel, &ufds);
+		CompSetZero(&hca->ib_trans.signal.set);
+		CompSetAdd(&hca->ib_hca_handle->channel, &hca->ib_trans.signal.set);
+		CompSetAdd(&hca->ib_trans.rch->comp_channel, &hca->ib_trans.signal.set);
 
 		next = dapl_llist_is_empty(&hca->ib_trans.list) ? NULL :
 			dapl_llist_peek_head(&hca->ib_trans.list);
@@ -1971,7 +1967,7 @@ void cm_thread(void *arg)
 
 		hca->ib_hca_handle->channel.Milliseconds = time_ms;
 		hca->ib_trans.rch->comp_channel.Milliseconds = time_ms;
-		CompSetPoll(&ufds, time_ms);
+		CompSetPoll(&hca->ib_trans.signal.set, time_ms);
 
 		hca->ib_hca_handle->channel.Milliseconds = 0;
 		hca->ib_trans.rch->comp_channel.Milliseconds = 0;
@@ -1979,19 +1975,13 @@ void cm_thread(void *arg)
 		ucm_async_event(hca);
 	}
 
-	CompSetCleanup(&ufds);
-	hca->ib_trans.cm_state = IB_THREAD_EXIT;
 	dapl_os_unlock(&hca->ib_trans.lock);
+	hca->ib_trans.cm_state = IB_THREAD_EXIT;
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " cm_thread(hca %p) exit\n", hca);
 }
 
 #else				// _WIN32 || _WIN64
 
-static void dapls_thread_signal(struct dapl_hca *hca)
-{
-	send(hca->ib_trans.scm[1], "w", sizeof "w", 0);
-}
-
 void cm_thread(void *arg)
 {
 	struct dapl_hca *hca = arg;
@@ -2011,7 +2001,7 @@ void cm_thread(void *arg)
 	while (1) {
 		time_ms = -1; /* reset to blocking */
 		dapl_fd_zero(set);
-		dapl_fd_set(hca->ib_trans.scm[0], set, DAPL_FD_READ);	
+		dapl_fd_set(hca->ib_trans.signal.scm[0], set, DAPL_FD_READ);	
 		dapl_fd_set(hca->ib_hca_handle->async_fd, set, DAPL_FD_READ);
 		dapl_fd_set(hca->ib_trans.rch->fd, set, DAPL_FD_READ);
 		
@@ -2056,9 +2046,9 @@ void cm_thread(void *arg)
 			      DAPL_FD_READ) == DAPL_FD_READ) {
 			ucm_async_event(hca);
 		}
-		while (dapl_poll(hca->ib_trans.scm[0], 
+		while (dapl_poll(hca->ib_trans.signal.scm[0], 
 				 DAPL_FD_READ) == DAPL_FD_READ) {
-			recv(hca->ib_trans.scm[0], rbuf, 2, 0);
+			recv(hca->ib_trans.signal.scm[0], rbuf, 2, 0);
 		}
 
 		dapl_os_lock(&hca->ib_trans.lock);
diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index 53f00bb..eef6384 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -87,7 +87,7 @@ typedef struct _ib_hca_transport
 	uint8_t			tclass;
 	uint8_t			mtu;
 	DAT_NAMED_ATTR		named_attr;
-	DAPL_SOCKET		scm[2];
+	struct dapl_thread_signal signal;
 	int			cqe;
 	int			qpe;
 	int			retries;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 4f26e87..65f5f9b 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -36,7 +36,21 @@
 static void ucm_service_destroy(IN DAPL_HCA *hca);
 static int  ucm_service_create(IN DAPL_HCA *hca);
 
-static int32_t create_cr_pipe(IN DAPL_HCA * hca_ptr)
+#if defined (_WIN32)
+
+static int32_t create_os_signal(IN DAPL_HCA * hca_ptr)
+{
+	return CompSetInit(&hca_ptr->ib_trans.signal.set);
+}
+
+static void destroy_os_signal(IN DAPL_HCA * hca_ptr)
+{
+	CompSetCleanup(&hca_ptr->ib_trans.signal.set);
+}
+
+#else // _WIN32
+
+static int32_t create_os_signal(IN DAPL_HCA * hca_ptr)
 {
 	DAPL_SOCKET listen_socket;
 	struct sockaddr_in addr;
@@ -62,35 +76,36 @@ static int32_t create_cr_pipe(IN DAPL_HCA * hca_ptr)
 	if (ret)
 		goto err1;
 
-	hca_ptr->ib_trans.scm[1] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
-	if (hca_ptr->ib_trans.scm[1] == DAPL_INVALID_SOCKET)
+	hca_ptr->ib_trans.signal.scm[1] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+	if (hca_ptr->ib_trans.signal.scm[1] == DAPL_INVALID_SOCKET)
 		goto err1;
 
-	ret = connect(hca_ptr->ib_trans.scm[1], 
+	ret = connect(hca_ptr->ib_trans.signal.scm[1], 
 		      (struct sockaddr *)&addr, sizeof(addr));
 	if (ret)
 		goto err2;
 
-	hca_ptr->ib_trans.scm[0] = accept(listen_socket, NULL, NULL);
-	if (hca_ptr->ib_trans.scm[0] == DAPL_INVALID_SOCKET)
+	hca_ptr->ib_trans.signal.scm[0] = accept(listen_socket, NULL, NULL);
+	if (hca_ptr->ib_trans.signal.scm[0] == DAPL_INVALID_SOCKET)
 		goto err2;
 
 	closesocket(listen_socket);
 	return 0;
 
       err2:
-	closesocket(hca_ptr->ib_trans.scm[1]);
+	closesocket(hca_ptr->ib_trans.signal.scm[1]);
       err1:
 	closesocket(listen_socket);
 	return 1;
 }
 
-static void destroy_cr_pipe(IN DAPL_HCA * hca_ptr)
+static void destroy_os_signal(IN DAPL_HCA * hca_ptr)
 {
-	closesocket(hca_ptr->ib_trans.scm[0]);
-	closesocket(hca_ptr->ib_trans.scm[1]);
+	closesocket(hca_ptr->ib_trans.signal.scm[0]);
+	closesocket(hca_ptr->ib_trans.signal.scm[1]);
 }
 
+#endif
 
 /*
  * dapls_ib_init, dapls_ib_release
@@ -117,28 +132,6 @@ int32_t dapls_ib_release(void)
 	return 0;
 }
 
-#if defined(_WIN64) || defined(_WIN32)
-int dapls_config_comp_channel(struct ibv_comp_channel *channel)
-{
-	return 0;
-}
-#else				// _WIN64 || WIN32
-int dapls_config_comp_channel(struct ibv_comp_channel *channel)
-{
-	int opts;
-
-	opts = fcntl(channel->fd, F_GETFL);	/* uCQ */
-	if (opts < 0 || fcntl(channel->fd, F_SETFL, opts | O_NONBLOCK) < 0) {
-		dapl_log(DAPL_DBG_TYPE_ERR,
-			 " dapls_create_comp_channel: fcntl on ib_cq->fd %d ERR %d %s\n",
-			 channel->fd, opts, strerror(errno));
-		return errno;
-	}
-
-	return 0;
-}
-#endif
-
 /*
  * dapls_ib_open_hca
  *
@@ -260,8 +253,7 @@ found:
 	if (ucm_service_create(hca_ptr))
 		goto bail;
 
-	/* initialize pipe, user level wakeup on select */
-	if (create_cr_pipe(hca_ptr)) {
+	if (create_os_signal(hca_ptr)) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " open_hca: failed to init cr pipe - %s\n",
 			 strerror(errno));
@@ -345,18 +337,18 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 
 	if (hca_ptr->ib_trans.cm_state == IB_THREAD_RUN) {
 		hca_ptr->ib_trans.cm_state = IB_THREAD_CANCEL;
-		send(hca_ptr->ib_trans.scm[1], "w", sizeof "w", 0);
+		dapls_thread_signal(&hca_ptr->ib_trans.signal);
 		while (hca_ptr->ib_trans.cm_state != IB_THREAD_EXIT) {
 			dapl_dbg_log(DAPL_DBG_TYPE_UTIL,
 				" close_hca: waiting for cr_thread\n");
-			send(hca_ptr->ib_trans.scm[1], "w", sizeof "w", 0);
+			dapls_thread_signal(&hca_ptr->ib_trans.signal);
 			dapl_os_sleep_usec(1000);
 		}
 	}
 
 	dapl_os_lock_destroy(&hca_ptr->ib_trans.lock);
 	dapl_os_lock_destroy(&hca_ptr->ib_trans.llock);
-	destroy_cr_pipe(hca_ptr); /* no longer need pipe */
+	destroy_os_signal(hca_ptr);
 	ucm_service_destroy(hca_ptr);
 
 	if (hca_ptr->ib_hca_handle != IB_INVALID_HANDLE) {
diff --git a/dapl/openib_ucm/linux/openib_osd.h b/dapl/openib_ucm/linux/openib_osd.h
index 191a55b..cf40fc9 100644
--- a/dapl/openib_ucm/linux/openib_osd.h
+++ b/dapl/openib_ucm/linux/openib_osd.h
@@ -18,4 +18,14 @@
 
 #define closesocket close
 
+struct dapl_thread_signal
+{
+	DAPL_SOCKET scm[2];
+};
+
+static void dapls_thread_signal(struct dapl_thread_signal *signal)
+{
+	send(signal->scm[1], "w", sizeof "w", 0);
+}
+
 #endif // OPENIB_OSD_H
diff --git a/dapl/openib_ucm/makefile b/dapl/openib_ucm/makefile
new file mode 100644
index 0000000..a0c0627
--- /dev/null
+++ b/dapl/openib_ucm/makefile
@@ -0,0 +1,7 @@
+#
+# DO NOT EDIT THIS FILE!!!  Edit .\sources. if you want to add a new source
+# file to this component.  This file merely indirects to the real make file
+# that is shared by all the driver components of the OpenIB Windows project.
+#
+
+!INCLUDE ..\..\..\..\inc\openib.def
diff --git a/dapl/openib_ucm/udapl.rc b/dapl/openib_ucm/udapl.rc
index 8550256..908376e 100644
--- a/dapl/openib_ucm/udapl.rc
+++ b/dapl/openib_ucm/udapl.rc
@@ -37,12 +37,12 @@
 
 #if DBG
 #define VER_FILEDESCRIPTION_STR		"Direct Access Provider Library v2.0 (OFA socket-cm) (Debug)"
-#define VER_INTERNALNAME_STR		"dapl2-ofa-scmd.dll"
-#define VER_ORIGINALFILENAME_STR	"dapl2-ofa-scmd.dll"
+#define VER_INTERNALNAME_STR		"dapl2-ofa-ucmd.dll"
+#define VER_ORIGINALFILENAME_STR	"dapl2-ofa-ucmd.dll"
 #else
 #define VER_FILEDESCRIPTION_STR		"Direct Access Provider Library v2.0 (OFA socket-cm)"
-#define VER_INTERNALNAME_STR		"dapl2-ofa-scm.dll"
-#define VER_ORIGINALFILENAME_STR	"dapl2-ofa-scm.dll"
+#define VER_INTERNALNAME_STR		"dapl2-ofa-ucm.dll"
+#define VER_ORIGINALFILENAME_STR	"dapl2-ofa-ucm.dll"
 #endif
 
 #include <common.ver>
diff --git a/dapl/openib_ucm/udapl_ofa_ucm_exports.src b/dapl/openib_ucm/udapl_ofa_ucm_exports.src
new file mode 100644
index 0000000..d74b7bb
--- /dev/null
+++ b/dapl/openib_ucm/udapl_ofa_ucm_exports.src
@@ -0,0 +1,14 @@
+#if DBG
+LIBRARY dapl2-ofa-ucmd.dll
+#else
+LIBRARY dapl2-ofa-ucm.dll
+#endif
+
+
+EXPORTS
+dat_provider_init
+dat_provider_fini
+#ifdef DAT_EXTENSIONS
+dapl_extensions
+#endif
+
diff --git a/dapl/openib_ucm/windows/openib_osd.h b/dapl/openib_ucm/windows/openib_osd.h
index 7eb3df3..73220dc 100644
--- a/dapl/openib_ucm/windows/openib_osd.h
+++ b/dapl/openib_ucm/windows/openib_osd.h
@@ -10,6 +10,7 @@
 #include <ws2tcpip.h>
 #include <io.h>
 #include <fcntl.h>
+#include <comp_channel.h>
 
 #define ntohll _byteswap_uint64
 #define htonll _byteswap_uint64
@@ -32,4 +33,14 @@ static int writev(DAPL_SOCKET s, struct iovec *vector, int count)
        return ret ? ret : len;
 }
 
+struct dapl_thread_signal
+{
+	COMP_SET set;
+};
+
+static void dapls_thread_signal(struct dapl_thread_signal *signal)
+{
+	CompSetCancel(&signal->set);
+}
+
 #endif // OPENIB_OSD_H
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
