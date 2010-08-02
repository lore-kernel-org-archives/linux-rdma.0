From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0 - common: cleanup CR linkings after DTO error on EP
Date: Mon, 2 Aug 2010 11:30:53 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983010FE6D305@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Add cleanup to remove CR from SP and EP
during DTO errors in dapli_evd_cqe_to_event.

dapl_sp_remove_ep needs to remove cr_ptr
reference from EP before freeing cr object.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_evd_util.c |    1 +
 dapl/common/dapl_sp_util.c  |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/dapl/common/dapl_evd_util.c b/dapl/common/dapl_evd_util.c
index cb3eb1b..12d38ff 100644
--- a/dapl/common/dapl_evd_util.c
+++ b/dapl/common/dapl_evd_util.c
@@ -1316,6 +1316,7 @@ dapli_evd_cqe_to_event(IN DAPL_EVD * evd_ptr,
 
 			/* ... and clean up the local side */
 			evd_ptr = (DAPL_EVD *) ep_ptr->param.connect_evd_handle;
+			dapl_sp_remove_ep (ep_ptr);
 			if (evd_ptr != NULL) {
 				dapls_evd_post_connection_event(evd_ptr,
 								DAT_CONNECTION_EVENT_BROKEN,
diff --git a/dapl/common/dapl_sp_util.c b/dapl/common/dapl_sp_util.c
index c1a3fdb..fba3711 100644
--- a/dapl/common/dapl_sp_util.c
+++ b/dapl/common/dapl_sp_util.c
@@ -264,6 +264,8 @@ void dapl_sp_remove_ep(IN DAPL_EP * ep_ptr)
 
 		dapl_os_unlock(&sp_ptr->header.lock);
 
+		ep_ptr->cr_ptr = NULL;
+
 		/* free memory outside of the lock */
 		dapls_cr_free(cr_ptr);
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
