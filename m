From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/10] DAPL v2.0: common: add new dapls_evd_post_event_ext
 call for extended events
Date: Thu, 11 Aug 2011 00:42:23 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B72@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add prototype and code to post extended events on dispatcher and
include collective definitions to dat_event_str function.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_evd_util.c |   61 ++++++++++++++++++++++++++++++++++++++++++-
 dapl/common/dapl_evd_util.h |    7 +++++
 2 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index 2a45400..9171415 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -91,7 +91,7 @@ char *dapl_event_str(IN DAT_EVENT_NUMBER event_num)
 		{"DAT_SOFTWARE_EVENT", DAT_SOFTWARE_EVENT},
 #ifdef DAT_EXTENSIONS
 		{"DAT_EXTENSION_EVENT", DAT_EXTENSION_EVENT},
-		{"DAT_IB_EXTENSION_RANGE_BASE", DAT_IB_EXTENSION_RANGE_BASE},
+		{"DAT_IB_DTO_EVENT", DAT_IB_EXTENSION_RANGE_BASE},
 		{"DAT_IB_UD_CONNECTION_REQUEST_EVENT",
 		 DAT_IB_EXTENSION_RANGE_BASE + 1},
 		{"DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED",
@@ -100,6 +100,8 @@ char *dapl_event_str(IN DAT_EVENT_NUMBER event_num)
 		 DAT_IB_EXTENSION_RANGE_BASE + 3},
 		{"DAT_IB_UD_CONNECTION_ERROR_EVENT",
 		 DAT_IB_EXTENSION_RANGE_BASE + 4},
+		{"DAT_IB_COLLECTIVE_EVENT",
+		 DAT_IB_EXTENSION_RANGE_BASE + 5},
 		{"DAT_IW_EXTENSION_RANGE_BASE", DAT_IW_EXTENSION_RANGE_BASE},
 #endif				/* DAT_EXTENSIONS */
 		{NULL, 0},
@@ -837,6 +839,63 @@ err:
 }
 
 #ifdef DAT_EXTENSIONS
+
+/*
+ * dapls_evd_post_event_ext
+ *
+ * Post a extended event type. Not used by all providers
+ *
+ * Input:
+ *	evd_ptr
+ * 	event_number
+ *	data
+ *	data_ext
+ *
+ * Output:
+ * 	none
+ *
+ * Returns:
+ * 	DAT_SUCCESS
+ *
+ */
+DAT_RETURN
+dapls_evd_post_event_ext(IN DAPL_EVD * evd_ptr,
+			 IN DAT_EVENT_NUMBER event_number,
+			 IN DAT_EVENT_DATA * data,
+			 IN DAT_UINT64 * data_ext)
+{
+	DAT_EVENT *event_ptr;
+
+	dapl_os_lock(&evd_ptr->header.lock);
+	event_ptr = dapli_evd_get_and_init_event(evd_ptr, event_number);
+	/*
+	 * Note event lock may be held on successful return
+	 * to be released by dapli_evd_post_event(), if provider side locking
+	 * is needed.
+	 */
+
+	if (event_ptr == NULL) {
+		dapl_os_unlock(&evd_ptr->header.lock);
+		return DAT_ERROR(DAT_INSUFFICIENT_RESOURCES,
+				 DAT_RESOURCE_MEMORY);
+	}
+
+	/* copy event and extended data */
+	if (data)
+		event_ptr->event_data = *data;
+	else
+		dapl_os_memzero(&event_ptr->event_data,
+				sizeof(event_ptr->event_data));
+
+	dapl_os_memcpy( (void*)event_ptr->event_extension_data,
+			(void *)data_ext,
+			sizeof(event_ptr->event_extension_data));
+
+	dapli_evd_post_event(evd_ptr, event_ptr);
+	dapl_os_unlock(&evd_ptr->header.lock);
+	return DAT_SUCCESS;
+}
+
 DAT_RETURN
 dapls_evd_do_post_cr_event_ext(IN DAPL_EVD * evd_ptr,
 				IN DAT_EVENT_NUMBER event_number,
diff --git a/dapl/common/dapl_evd_util.h b/dapl/common/dapl_evd_util.h
index 65472d7..3d6dbeb 100644
--- a/dapl/common/dapl_evd_util.h
+++ b/dapl/common/dapl_evd_util.h
@@ -111,6 +111,13 @@ dapls_evd_post_generic_event (
 
 #ifdef DAT_EXTENSIONS
 DAT_RETURN
+dapls_evd_post_event_ext(
+    IN DAPL_EVD				*evd_ptr,
+    IN DAT_EVENT_NUMBER			event_number,
+    IN DAT_EVENT_DATA			*data,
+    IN DAT_UINT64			*data_ext);
+
+DAT_RETURN
 dapls_evd_post_cr_event_ext (
     IN DAPL_SP				*sp_ptr,
     IN DAT_EVENT_NUMBER			event_number,
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
