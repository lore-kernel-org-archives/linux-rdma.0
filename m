From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/10] DAPL v2.0: ucm: add support for IB collective drivers
 in UD IB cm provider
Date: Thu, 11 Aug 2011 00:42:18 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B67@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add collective member address and threading information
on a per transport basis. Call create/free service with
HCA open/close.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/dapl_ib_util.h |   17 +++++++++++++++++
 dapl/openib_ucm/device.c       |   13 +++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_ucm/dapl_ib_util.h b/dapl/openib_ucm/dapl_ib_util.h
index efeec4d..b5bd082 100644
--- a/dapl/openib_ucm/dapl_ib_util.h
+++ b/dapl/openib_ucm/dapl_ib_util.h
@@ -120,6 +120,23 @@ typedef struct _ib_hca_transport
 	uint8_t			sl;
 	uint16_t		pkey;
 	int			pkey_idx;
+#ifdef DAT_IB_COLLECTIVES
+	/* Collective member device and address information */
+	ib_thread_state_t 	coll_thread_state;
+	DAPL_OS_THREAD 		coll_thread;
+	DAPL_OS_LOCK 		coll_lock;
+	DAPL_OS_WAIT_OBJECT 	coll_event;
+	struct dapl_llist_entry *grp_list;
+	user_progress_func_t 	*user_func;
+	int 			l_sock;
+	struct sockaddr_in	m_addr;
+	void 			*m_ctx;
+	void			*m_info;
+	void			*f_info;
+	int			m_size;
+	int			f_size;
+	int			t_id;
+#endif
 
 } ib_hca_transport_t;
 
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index a628a78..a07d886 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -33,6 +33,10 @@
 
 #include <stdlib.h>
 
+#ifdef DAT_IB_COLLECTIVES
+#include <collectives/ib_collectives.h>
+#endif
+
 static void ucm_service_destroy(IN DAPL_HCA *hca);
 static int  ucm_service_create(IN DAPL_HCA *hca);
 
@@ -347,6 +351,11 @@ found:
 	       &hca_ptr->ib_trans.addr, 
 	       sizeof(union dcm_addr));
 
+#ifdef DAT_IB_COLLECTIVES
+	if (dapli_create_collective_service(hca_ptr))
+		goto bail;
+#endif
+
 	ibv_free_device_list(dev_list);
 
 	/* wait for cm_thread */
@@ -385,6 +394,10 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 {
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " close_hca: %p\n", hca_ptr);
 
+#ifdef DAT_IB_COLLECTIVES
+	dapli_free_collective_service(hca_ptr);
+#endif
+
 	if (hca_ptr->ib_trans.cm_state == IB_THREAD_RUN) {
 		hca_ptr->ib_trans.cm_state = IB_THREAD_CANCEL;
 		dapls_thread_signal(&hca_ptr->ib_trans.signal);
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
