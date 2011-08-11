From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/10] DAPL v2.0: cma: add support for IB collective drivers
 in rdma_cm provider
Date: Thu, 11 Aug 2011 00:42:07 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F916E42B54@FMSMSX151.amr.corp.intel.com>
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
 dapl/openib_cma/dapl_ib_util.h |   17 +++++++++++++++++
 dapl/openib_cma/device.c       |   13 +++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_util.h b/dapl/openib_cma/dapl_ib_util.h
index 471bd7f..454f7e1 100755
--- a/dapl/openib_cma/dapl_ib_util.h
+++ b/dapl/openib_cma/dapl_ib_util.h
@@ -124,6 +124,23 @@ typedef struct _ib_hca_transport
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
 
 /* prototypes */
diff --git a/dapl/openib_cma/device.c b/dapl/openib_cma/device.c
index 454c394..d1a3ab6 100644
--- a/dapl/openib_cma/device.c
+++ b/dapl/openib_cma/device.c
@@ -47,6 +47,10 @@ static const char rcsid[] = "$Id:  $";
 
 #include <stdlib.h>
 
+#ifdef DAT_IB_COLLECTIVES
+#include <collectives/ib_collectives.h>
+#endif
+
 struct rdma_event_channel *g_cm_events = NULL;
 ib_thread_state_t g_ib_thread_state = 0;
 DAPL_OS_THREAD g_ib_thread;
@@ -376,6 +380,11 @@ DAT_RETURN dapls_ib_open_hca(IN IB_HCA_NAME hca_name, IN DAPL_HCA * hca_ptr)
 		     &hca_ptr->hca_address)->sin_addr.s_addr >> 24 & 0xff, 
 		     hca_ptr->ib_trans.max_inline_send);
 
+#ifdef DAT_IB_COLLECTIVES
+	if (dapli_create_collective_service(hca_ptr))
+		return DAT_INTERNAL_ERROR;
+#endif
+
 	return DAT_SUCCESS;
 }
 
@@ -400,6 +409,10 @@ DAT_RETURN dapls_ib_close_hca(IN DAPL_HCA * hca_ptr)
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL, " close_hca: %p->%p\n",
 		     hca_ptr, hca_ptr->ib_hca_handle);
 
+#ifdef DAT_IB_COLLECTIVES
+	dapli_free_collective_service(hca_ptr);
+#endif
+
 	dapl_os_lock(&g_hca_lock);
 	if (g_ib_thread_state != IB_THREAD_RUN) {
 		dapl_os_unlock(&g_hca_lock);
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
