From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/12] dapl-2.0: common: dat_ep_connect should not set timer
 UD endpoints
Date: Wed, 19 May 2010 11:11:31 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C701308A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


connect for UD type is simply AH resolution and doesn't
need timed. The common code is not designed to handle
multiple timed events on connect requests so just ignore
timing UD AH requests.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/common/dapl_ep_connect.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/dapl/common/dapl_ep_connect.c b/dapl/common/dapl_ep_connect.c
index 1f193ae..9b5829e 100755
--- a/dapl/common/dapl_ep_connect.c
+++ b/dapl/common/dapl_ep_connect.c
@@ -327,7 +327,8 @@ dapl_ep_connect(IN DAT_EP_HANDLE ep_handle,
 		dapl_os_lock(&ep_ptr->header.lock);
 		if (ep_ptr->param.ep_state ==
 		    DAT_EP_STATE_ACTIVE_CONNECTION_PENDING
-		    && timeout != DAT_TIMEOUT_INFINITE) {
+		    && timeout != DAT_TIMEOUT_INFINITE &&
+	    	    ep_ptr->param.ep_attr.service_type == DAT_SERVICE_TYPE_RC) {
 			ep_ptr->cxn_timer =
 			    (DAPL_OS_TIMER *)
 			    dapl_os_alloc(sizeof(DAPL_OS_TIMER));
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
