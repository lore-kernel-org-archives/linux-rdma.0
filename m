From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] compat-dapl-1.2: cma: memory leak of FD's (pipe)
 created during dat_evd_create
Date: Wed, 19 May 2010 09:42:49 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C7012E94@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add checking for pipe FD's during destroy and clean them up with close.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/dapl_ib_cq.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_cma/dapl_ib_cq.c b/dapl/openib_cma/dapl_ib_cq.c
index cf19f38..c54bbaf 100644
--- a/dapl/openib_cma/dapl_ib_cq.c
+++ b/dapl/openib_cma/dapl_ib_cq.c
@@ -462,8 +462,11 @@ dapls_ib_wait_object_create(IN DAPL_EVD *evd_ptr,
 		ibv_create_comp_channel(
 			evd_ptr->header.owner_ia->hca_ptr->ib_hca_handle);	
 		
-	if ((*p_cq_wait_obj_handle)->events == NULL) 		
+	if ((*p_cq_wait_obj_handle)->events == NULL) {
+		close((*p_cq_wait_obj_handle)->pipe[0]);
+		close((*p_cq_wait_obj_handle)->pipe[1]);
 		goto bail;
+	}
 
 	return DAT_SUCCESS;
 bail:
@@ -483,6 +486,9 @@ dapls_ib_wait_object_destroy(IN ib_wait_obj_handle_t p_cq_wait_obj_handle)
 	
 	ibv_destroy_comp_channel(p_cq_wait_obj_handle->events);
 
+	close(p_cq_wait_obj_handle->pipe[0]);
+	close(p_cq_wait_obj_handle->pipe[1]);
+
 	dapl_os_free(p_cq_wait_obj_handle, 
 		     sizeof(struct _ib_wait_obj_handle));
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
