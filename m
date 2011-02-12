From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0:  cma: reduce output log level in disconnect from
 WARN to CM_WARN
Date: Sat, 12 Feb 2011 11:27:29 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98301272F4059@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 dapl/openib_cma/cm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index f010b8a..7980cf6 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -649,7 +649,7 @@ dapls_ib_disconnect(IN DAPL_EP * ep_ptr, IN DAT_CLOSE_FLAGS close_flags)
 			dapl_os_lock(&ep_ptr->header.lock);
 		}
 		if (ep_ptr->param.ep_state != DAT_EP_STATE_DISCONNECTED) {
-			dapl_log(DAPL_DBG_TYPE_WARN,
+			dapl_log(DAPL_DBG_TYPE_CM_WARN,
 				 " WARNING: disconnect(ep %p, conn %p, id %d) timed out\n",
 				 ep_ptr, conn, (conn ? conn->cm_id : 0));
 			ep_ptr->param.ep_state = DAT_EP_STATE_DISCONNECTED;
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
