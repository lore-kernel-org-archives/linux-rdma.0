From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/12] dapl-2.0: scm, cma, ucm: consolidate dat
 event/provider event translation
Date: Wed, 19 May 2010 11:11:24 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013084@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c      |  108 -------------------------------------------
 dapl/openib_common/util.c |  107 +++++++++++++++++++++++++++++++++++++++++++
 dapl/openib_scm/cm.c      |  112 ++-------------------------------------------
 dapl/openib_ucm/cm.c      |   99 ---------------------------------------
 4 files changed, 111 insertions(+), 315 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index a85e6ae..1e846aa 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -1051,114 +1051,6 @@ int dapls_ib_private_data_size(IN DAPL_HCA * hca_ptr)
 	return RDMA_MAX_PRIVATE_DATA;
 }
 
-/*
- * Map all CMA event codes to the DAT equivelent.
- */
-#define DAPL_IB_EVENT_CNT	13
-
-static struct ib_cm_event_map {
-	const ib_cm_events_t ib_cm_event;
-	DAT_EVENT_NUMBER dat_event_num;
-} ib_cm_event_map[DAPL_IB_EVENT_CNT] = {
-	/* 00 */  {
-	IB_CME_CONNECTED, DAT_CONNECTION_EVENT_ESTABLISHED},
-	    /* 01 */  {
-	IB_CME_DISCONNECTED, DAT_CONNECTION_EVENT_DISCONNECTED},
-	    /* 02 */  {
-	IB_CME_DISCONNECTED_ON_LINK_DOWN,
-		    DAT_CONNECTION_EVENT_DISCONNECTED},
-	    /* 03 */  {
-	IB_CME_CONNECTION_REQUEST_PENDING, DAT_CONNECTION_REQUEST_EVENT},
-	    /* 04 */  {
-	IB_CME_CONNECTION_REQUEST_PENDING_PRIVATE_DATA,
-		    DAT_CONNECTION_REQUEST_EVENT},
-	    /* 05 */  {
-	IB_CME_CONNECTION_REQUEST_ACKED, DAT_CONNECTION_REQUEST_EVENT},
-	    /* 06 */  {
-	IB_CME_DESTINATION_REJECT,
-		    DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
-	    /* 07 */  {
-	IB_CME_DESTINATION_REJECT_PRIVATE_DATA,
-		    DAT_CONNECTION_EVENT_PEER_REJECTED},
-	    /* 08 */  {
-	IB_CME_DESTINATION_UNREACHABLE, DAT_CONNECTION_EVENT_UNREACHABLE},
-	    /* 09 */  {
-	IB_CME_TOO_MANY_CONNECTION_REQUESTS,
-		    DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
-	    /* 10 */  {
-	IB_CME_LOCAL_FAILURE, DAT_CONNECTION_EVENT_BROKEN},
-	    /* 11 */  {
-	IB_CME_BROKEN, DAT_CONNECTION_EVENT_BROKEN},
-	    /* 12 */  {
-IB_CME_TIMEOUT, DAT_CONNECTION_EVENT_TIMED_OUT},};
-
-/*
- * dapls_ib_get_cm_event
- *
- * Return a DAT connection event given a provider CM event.
- *
- * Input:
- *	dat_event_num	DAT event we need an equivelent CM event for
- *
- * Output:
- * 	none
- *
- * Returns:
- * 	ib_cm_event of translated DAPL value
- */
-DAT_EVENT_NUMBER
-dapls_ib_get_dat_event(IN const ib_cm_events_t ib_cm_event,
-		       IN DAT_BOOLEAN active)
-{
-	DAT_EVENT_NUMBER dat_event_num;
-	int i;
-
-	active = active;
-
-	dat_event_num = 0;
-	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
-		if (ib_cm_event == ib_cm_event_map[i].ib_cm_event) {
-			dat_event_num = ib_cm_event_map[i].dat_event_num;
-			break;
-		}
-	}
-	dapl_dbg_log(DAPL_DBG_TYPE_CALLBACK,
-		     "dapls_ib_get_dat_event: event(%s) ib=0x%x dat=0x%x\n",
-		     active ? "active" : "passive", ib_cm_event, dat_event_num);
-
-	return dat_event_num;
-}
-
-/*
- * dapls_ib_get_dat_event
- *
- * Return a DAT connection event given a provider CM event.
- * 
- * Input:
- *	ib_cm_event	event provided to the dapl callback routine
- *	active		switch indicating active or passive connection
- *
- * Output:
- * 	none
- *
- * Returns:
- * 	DAT_EVENT_NUMBER of translated provider value
- */
-ib_cm_events_t dapls_ib_get_cm_event(IN DAT_EVENT_NUMBER dat_event_num)
-{
-	ib_cm_events_t ib_cm_event;
-	int i;
-
-	ib_cm_event = 0;
-	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
-		if (dat_event_num == ib_cm_event_map[i].dat_event_num) {
-			ib_cm_event = ib_cm_event_map[i].ib_cm_event;
-			break;
-		}
-	}
-	return ib_cm_event;
-}
-
 void dapli_cma_event_cb(void)
 {
 	struct rdma_cm_event *event;
diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index 3963e1f..704d85a 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -471,3 +471,110 @@ void dapls_query_provider_specific_attr(IN DAPL_IA * ia_ptr,
 	/* set MTU to actual settings */
 	ib_attrs[0].value = ia_ptr->hca_ptr->ib_trans.named_attr.value;
 }
+
+/*
+ * Map all socket CM event codes to the DAT equivelent. Common to all providers
+ */
+#define DAPL_IB_EVENT_CNT	13
+
+static struct ib_cm_event_map {
+	const ib_cm_events_t ib_cm_event;
+	DAT_EVENT_NUMBER dat_event_num;
+} ib_cm_event_map[DAPL_IB_EVENT_CNT] = {
+/* 00 */ {IB_CME_CONNECTED, 
+	  DAT_CONNECTION_EVENT_ESTABLISHED},
+/* 01 */ {IB_CME_DISCONNECTED, 
+	  DAT_CONNECTION_EVENT_DISCONNECTED},
+/* 02 */ {IB_CME_DISCONNECTED_ON_LINK_DOWN,
+	  DAT_CONNECTION_EVENT_DISCONNECTED},
+/* 03 */ {IB_CME_CONNECTION_REQUEST_PENDING, 
+	  DAT_CONNECTION_REQUEST_EVENT},
+/* 04 */ {IB_CME_CONNECTION_REQUEST_PENDING_PRIVATE_DATA,
+	  DAT_CONNECTION_REQUEST_EVENT},
+/* 05 */ {IB_CME_CONNECTION_REQUEST_ACKED,
+	  DAT_CONNECTION_EVENT_ESTABLISHED},
+/* 06 */ {IB_CME_DESTINATION_REJECT,
+	  DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
+/* 07 */ {IB_CME_DESTINATION_REJECT_PRIVATE_DATA,
+	  DAT_CONNECTION_EVENT_PEER_REJECTED},
+/* 08 */ {IB_CME_DESTINATION_UNREACHABLE, 
+	  DAT_CONNECTION_EVENT_UNREACHABLE},
+/* 09 */ {IB_CME_TOO_MANY_CONNECTION_REQUESTS,
+	  DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
+/* 10 */ {IB_CME_BROKEN, 
+	  DAT_CONNECTION_EVENT_BROKEN},
+/* 11 */ {IB_CME_TIMEOUT, 
+	  DAT_CONNECTION_EVENT_TIMED_OUT},
+/* 12 */ {IB_CME_LOCAL_FAILURE,		/* always last */
+	  DAT_CONNECTION_EVENT_BROKEN}
+};
+
+/*
+ * dapls_ib_get_cm_event
+ *
+ * Return a DAT connection event given a provider CM event.
+ *
+ * Input:
+ *	dat_event_num	DAT event we need an equivelent CM event for
+ *
+ * Output:
+ * 	none
+ *
+ * Returns:
+ * 	ib_cm_event of translated DAPL value
+ */
+DAT_EVENT_NUMBER
+dapls_ib_get_dat_event(IN const ib_cm_events_t ib_cm_event,
+		       IN DAT_BOOLEAN active)
+{
+	DAT_EVENT_NUMBER dat_event_num;
+	int i;
+
+	active = active;
+
+	if (ib_cm_event > IB_CME_LOCAL_FAILURE)
+		return (DAT_EVENT_NUMBER) 0;
+
+	dat_event_num = 0;
+	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
+		if (ib_cm_event == ib_cm_event_map[i].ib_cm_event) {
+			dat_event_num = ib_cm_event_map[i].dat_event_num;
+			break;
+		}
+	}
+	dapl_dbg_log(DAPL_DBG_TYPE_CALLBACK,
+		     "dapls_ib_get_dat_event: event translate(%s) ib=0x%x dat=0x%x\n",
+		     active ? "active" : "passive", ib_cm_event, dat_event_num);
+
+	return dat_event_num;
+}
+
+/*
+ * dapls_ib_get_dat_event
+ *
+ * Return a DAT connection event given a provider CM event.
+ * 
+ * Input:
+ *	ib_cm_event	event provided to the dapl callback routine
+ *	active		switch indicating active or passive connection
+ *
+ * Output:
+ * 	none
+ *
+ * Returns:
+ * 	DAT_EVENT_NUMBER of translated provider value
+ */
+ib_cm_events_t dapls_ib_get_cm_event(IN DAT_EVENT_NUMBER dat_event_num)
+{
+	ib_cm_events_t ib_cm_event;
+	int i;
+
+	ib_cm_event = 0;
+	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
+		if (dat_event_num == ib_cm_event_map[i].dat_event_num) {
+			ib_cm_event = ib_cm_event_map[i].ib_cm_event;
+			break;
+		}
+	}
+	return ib_cm_event;
+}
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 39f8417..957066a 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -501,7 +501,7 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 
 bail:
 	/* mark CM object for cleanup */
-	cm_ptr->state = DCM_FREE;
+	dapli_cm_free(cm_ptr);
 	dapl_evd_connection_callback(NULL, IB_CME_LOCAL_FAILURE, NULL, 0, ep_ptr);
 }
 
@@ -816,9 +816,7 @@ ud_bail:
 				(DAT_PVOID *) &xevent);
 
 		/* cleanup and release from local list */
-		dapl_os_lock(&cm_ptr->lock);
-		cm_ptr->state = DCM_FREE;
-		dapl_os_unlock(&cm_ptr->lock);		
+		dapli_cm_free(cm_ptr);
 	
 	} else
 #endif
@@ -836,10 +834,9 @@ bail:
 #endif
 	/* close socket, and post error event */
 	cm_ptr->state = DCM_REJECTED;
-	closesocket(cm_ptr->socket);
-        cm_ptr->socket = DAPL_INVALID_SOCKET;
 	dapl_evd_connection_callback(NULL, event, cm_ptr->msg.p_data,
 				     DCM_MAX_PDATA_SIZE, ep_ptr);
+	dapli_cm_free(cm_ptr);
 }
 
 /*
@@ -1041,7 +1038,7 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
 	return;
 bail:
 	/* mark for destroy, active will see socket close as rej */
-	acm_ptr->state = DCM_FREE;
+	dapli_cm_free(acm_ptr);
 	return;
 }
 
@@ -1573,107 +1570,6 @@ int dapls_ib_private_data_size(
 	return DCM_MAX_PDATA_SIZE;
 }
 
-/*
- * Map all socket CM event codes to the DAT equivelent.
- */
-#define DAPL_IB_EVENT_CNT	10
-
-static struct ib_cm_event_map {
-	const ib_cm_events_t ib_cm_event;
-	DAT_EVENT_NUMBER dat_event_num;
-} ib_cm_event_map[DAPL_IB_EVENT_CNT] = {
-/* 00 */ {IB_CME_CONNECTED, 
-	  DAT_CONNECTION_EVENT_ESTABLISHED},
-/* 01 */ {IB_CME_DISCONNECTED, 
-	  DAT_CONNECTION_EVENT_DISCONNECTED},
-/* 02 */ {IB_CME_DISCONNECTED_ON_LINK_DOWN,
-	  DAT_CONNECTION_EVENT_DISCONNECTED},
-/* 03 */ {IB_CME_CONNECTION_REQUEST_PENDING, 
-	  DAT_CONNECTION_REQUEST_EVENT},
-/* 04 */ {IB_CME_CONNECTION_REQUEST_PENDING_PRIVATE_DATA,
-	  DAT_CONNECTION_REQUEST_EVENT},
-/* 05 */ {IB_CME_DESTINATION_REJECT,
-	  DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
-/* 06 */ {IB_CME_DESTINATION_REJECT_PRIVATE_DATA,
-	  DAT_CONNECTION_EVENT_PEER_REJECTED},
-/* 07 */ {IB_CME_DESTINATION_UNREACHABLE, 
-	  DAT_CONNECTION_EVENT_UNREACHABLE},
-/* 08 */ {IB_CME_TOO_MANY_CONNECTION_REQUESTS,
-	  DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
-/* 09 */ {IB_CME_LOCAL_FAILURE, 
-	  DAT_CONNECTION_EVENT_BROKEN}
-};
-
-/*
- * dapls_ib_get_cm_event
- *
- * Return a DAT connection event given a provider CM event.
- *
- * Input:
- *	dat_event_num	DAT event we need an equivelent CM event for
- *
- * Output:
- * 	none
- *
- * Returns:
- * 	ib_cm_event of translated DAPL value
- */
-DAT_EVENT_NUMBER
-dapls_ib_get_dat_event(IN const ib_cm_events_t ib_cm_event,
-		       IN DAT_BOOLEAN active)
-{
-	DAT_EVENT_NUMBER dat_event_num;
-	int i;
-
-	active = active;
-
-	if (ib_cm_event > IB_CME_LOCAL_FAILURE)
-		return (DAT_EVENT_NUMBER) 0;
-
-	dat_event_num = 0;
-	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
-		if (ib_cm_event == ib_cm_event_map[i].ib_cm_event) {
-			dat_event_num = ib_cm_event_map[i].dat_event_num;
-			break;
-		}
-	}
-	dapl_dbg_log(DAPL_DBG_TYPE_CALLBACK,
-		     "dapls_ib_get_dat_event: event translate(%s) ib=0x%x dat=0x%x\n",
-		     active ? "active" : "passive", ib_cm_event, dat_event_num);
-
-	return dat_event_num;
-}
-
-/*
- * dapls_ib_get_dat_event
- *
- * Return a DAT connection event given a provider CM event.
- * 
- * Input:
- *	ib_cm_event	event provided to the dapl callback routine
- *	active		switch indicating active or passive connection
- *
- * Output:
- * 	none
- *
- * Returns:
- * 	DAT_EVENT_NUMBER of translated provider value
- */
-ib_cm_events_t dapls_ib_get_cm_event(IN DAT_EVENT_NUMBER dat_event_num)
-{
-	ib_cm_events_t ib_cm_event;
-	int i;
-
-	ib_cm_event = 0;
-	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
-		if (dat_event_num == ib_cm_event_map[i].dat_event_num) {
-			ib_cm_event = ib_cm_event_map[i].ib_cm_event;
-			break;
-		}
-	}
-	return ib_cm_event;
-}
-
 /* outbound/inbound CR processing thread to avoid blocking applications */
 void cr_thread(void *arg)
 {
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 6efa2f1..2cab529 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1817,105 +1817,6 @@ int dapls_ib_private_data_size(
 	return DCM_MAX_PDATA_SIZE;
 }
 
-/*
- * Map all socket CM event codes to the DAT equivelent.
- */
-#define DAPL_IB_EVENT_CNT	10
-
-static struct ib_cm_event_map {
-	const ib_cm_events_t ib_cm_event;
-	DAT_EVENT_NUMBER dat_event_num;
-} ib_cm_event_map[DAPL_IB_EVENT_CNT] = {
-/* 00 */ {IB_CME_CONNECTED, 
-	  DAT_CONNECTION_EVENT_ESTABLISHED},
-/* 01 */ {IB_CME_DISCONNECTED, 
-	  DAT_CONNECTION_EVENT_DISCONNECTED},
-/* 02 */ {IB_CME_DISCONNECTED_ON_LINK_DOWN,
-	  DAT_CONNECTION_EVENT_DISCONNECTED},
-/* 03 */ {IB_CME_CONNECTION_REQUEST_PENDING, 
-	  DAT_CONNECTION_REQUEST_EVENT},
-/* 04 */ {IB_CME_CONNECTION_REQUEST_PENDING_PRIVATE_DATA,
-	  DAT_CONNECTION_REQUEST_EVENT},
-/* 05 */ {IB_CME_DESTINATION_REJECT,
-	  DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
-/* 06 */ {IB_CME_DESTINATION_REJECT_PRIVATE_DATA,
-	  DAT_CONNECTION_EVENT_PEER_REJECTED},
-/* 07 */ {IB_CME_DESTINATION_UNREACHABLE, 
-	  DAT_CONNECTION_EVENT_UNREACHABLE},
-/* 08 */ {IB_CME_TOO_MANY_CONNECTION_REQUESTS,
-	  DAT_CONNECTION_EVENT_NON_PEER_REJECTED},
-/* 09 */ {IB_CME_LOCAL_FAILURE, 
-	  DAT_CONNECTION_EVENT_BROKEN}
-};
-
-/*
- * dapls_ib_get_cm_event
- *
- * Return a DAT connection event given a provider CM event.
- *
- * Input:
- *	dat_event_num	DAT event we need an equivelent CM event for
- *
- * Output:
- * 	none
- *
- * Returns:
- * 	ib_cm_event of translated DAPL value
- */
-DAT_EVENT_NUMBER
-dapls_ib_get_dat_event(IN const ib_cm_events_t ib_cm_event,
-		       IN DAT_BOOLEAN active)
-{
-	DAT_EVENT_NUMBER dat_event_num;
-	int i;
-
-	if (ib_cm_event > IB_CME_LOCAL_FAILURE)
-		return (DAT_EVENT_NUMBER) 0;
-
-	dat_event_num = 0;
-	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
-		if (ib_cm_event == ib_cm_event_map[i].ib_cm_event) {
-			dat_event_num = ib_cm_event_map[i].dat_event_num;
-			break;
-		}
-	}
-	dapl_dbg_log(DAPL_DBG_TYPE_CALLBACK,
-		     "dapls_ib_get_dat_event: event translate(%s) ib=0x%x dat=0x%x\n",
-		     active ? "active" : "passive", ib_cm_event, dat_event_num);
-
-	return dat_event_num;
-}
-
-/*
- * dapls_ib_get_dat_event
- *
- * Return a DAT connection event given a provider CM event.
- * 
- * Input:
- *	ib_cm_event	event provided to the dapl callback routine
- *	active		switch indicating active or passive connection
- *
- * Output:
- * 	none
- *
- * Returns:
- * 	DAT_EVENT_NUMBER of translated provider value
- */
-ib_cm_events_t dapls_ib_get_cm_event(IN DAT_EVENT_NUMBER dat_event_num)
-{
-	ib_cm_events_t ib_cm_event;
-	int i;
-
-	ib_cm_event = 0;
-	for (i = 0; i < DAPL_IB_EVENT_CNT; i++) {
-		if (dat_event_num == ib_cm_event_map[i].dat_event_num) {
-			ib_cm_event = ib_cm_event_map[i].ib_cm_event;
-			break;
-		}
-	}
-	return ib_cm_event;
-}
-
 #if defined(_WIN32) || defined(_WIN64)
 
 void cm_thread(void *arg)
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
