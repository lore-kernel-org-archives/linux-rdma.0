From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/12] dapl-2.0: scm: add EP locking and cm checking to
 socket cm disconnect
Date: Wed, 19 May 2010 11:11:35 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C701308C@orsmsx506.amr.corp.intel.com>
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
 dapl/openib_scm/cm.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index b6ffbe9..afd0d93 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -1410,11 +1410,14 @@ dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 {
 	dp_ib_cm_handle_t cm_ptr = dapl_get_cm_from_ep(ep_ptr);
 
+	dapl_os_lock(&ep_ptr->header.lock);
 	if (ep_ptr->param.ep_state == DAT_EP_STATE_DISCONNECTED ||
-		ep_ptr->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC) {
+	    ep_ptr->param.ep_attr.service_type != DAT_SERVICE_TYPE_RC ||
+	    cm_ptr == NULL) {
+		dapl_os_unlock(&ep_ptr->header.lock);
 		return DAT_SUCCESS;
 	} 
-	
+	dapl_os_unlock(&ep_ptr->header.lock);
 	return (dapli_socket_disconnect(cm_ptr));
 }
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
