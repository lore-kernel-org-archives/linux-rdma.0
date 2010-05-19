From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/12] dapl-2.0: scm: add support for canceling conn request
 that times out.
Date: Wed, 19 May 2010 11:11:26 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7013085@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


print warning message during timeout.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_connect.c |    2 ++
 dapl/openib_scm/cm.c          |   11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/dapl/common/dapl_ep_connect.c b/dapl/common/dapl_ep_connect.c
index 4e5e112..1f193ae 100755
--- a/dapl/common/dapl_ep_connect.c
+++ b/dapl/common/dapl_ep_connect.c
@@ -334,6 +334,8 @@ dapl_ep_connect(IN DAT_EP_HANDLE ep_handle,
 
 			dapls_timer_set(ep_ptr->cxn_timer,
 					dapls_ep_timeout, ep_ptr, timeout);
+
+			dapl_log(DAPL_DBG_TYPE_WARN, " dapl_ep_connect timeout = %d us\n", timeout);
 		}
 		dapl_os_unlock(&ep_ptr->header.lock);
 	}
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 957066a..6958b67 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -1366,7 +1366,16 @@ dapls_ib_disconnect_clean(IN DAPL_EP * ep_ptr,
 			  IN DAT_BOOLEAN active,
 			  IN const ib_cm_events_t ib_cm_event)
 {
-	/* nothing to cleanup */
+	if (ib_cm_event == IB_CME_TIMEOUT) {
+		dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);
+
+		dapl_log(DAPL_DBG_TYPE_WARN,
+			"dapls_ib_disc_clean: CONN_TIMEOUT ep %p cm %p %s\n",
+			ep_ptr, cm_ptr, dapl_cm_state_str(cm_ptr->state));
+		
+		/* schedule release of socket and local resources */
+		dapli_cm_free(cm_ptr);
+	}
 }
 
 /*
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
