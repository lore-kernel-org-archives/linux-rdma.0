From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] DAPL v2.0: common: modify debug in dat_evd_dequeue to
 reduce noise, only output on non-empty
Date: Fri, 22 Oct 2010 13:15:51 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983011BA209E7@orsmsx506.amr.corp.intel.com>
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
 dapl/common/dapl_evd_dequeue.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/dapl/common/dapl_evd_dequeue.c b/dapl/common/dapl_evd_dequeue.c
index 7632fe1..f31e497 100644
--- a/dapl/common/dapl_evd_dequeue.c
+++ b/dapl/common/dapl_evd_dequeue.c
@@ -69,9 +69,6 @@ DAT_RETURN DAT_API dapl_evd_dequeue(IN DAT_EVD_HANDLE evd_handle,
 	DAT_EVENT *local_event;
 	DAT_RETURN dat_status;
 
-	dapl_dbg_log(DAPL_DBG_TYPE_API,
-		     "dapl_evd_dequeue (%p, %p)\n", evd_handle, event);
-
 	evd_ptr = (DAPL_EVD *) evd_handle;
 	dat_status = DAT_SUCCESS;
 
@@ -125,10 +122,14 @@ DAT_RETURN DAT_API dapl_evd_dequeue(IN DAT_EVD_HANDLE evd_handle,
 		DAPL_CNTR(evd_ptr, DCNT_EVD_DEQUEUE_NOT_FOUND);
 	}
 
+#ifdef DAPL_DBG
+	if (dat_status == DAT_SUCCESS) 
+		dapl_dbg_log(DAPL_DBG_TYPE_EVD,
+			     "dapl_evd_dequeue() Event(%p) = 0x%x\n",
+			     event->evd_handle, event->event_number);
+#endif
 	dapl_os_unlock(&evd_ptr->header.lock);
       bail:
-	dapl_dbg_log(DAPL_DBG_TYPE_RTN,
-		     "dapl_evd_dequeue () returns 0x%x\n", dat_status);
 
 	return dat_status;
 }
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
