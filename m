From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/9] dapl-2.0: ucm: UD mode, active side cm object released
 to soon, the RTU could be lost.
Date: Wed, 19 May 2010 11:25:19 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130DD@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Will see following message with DAPL_DBG_TYPE set for Errors & Warnings (0x3):
ucm_recv: NO MATCH op REP 0x120 65487 i0x60005e c0x60005e < 0xd2 19824 0x60006a

The cm object was released on the active side after the connection
was established, RTU sent. This is a problem if the RTU is lost
and the remote side retries the REPLY. The RTU is never resent.
Keep the cm object until the EP is destroyed.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index c82147e..94af988 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1143,10 +1143,6 @@ ud_bail:
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
-
-		/* release cm_ptr, EP refs will prevent destroy */
-		dapli_cm_free(cm);
-				
 	} else
 #endif
 	{
@@ -1310,10 +1306,6 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
-
-                /* done with CM object, EP ref will hold object for pdata */
-		dapli_cm_free(cm);
-		
 	} else {
 #endif
 		dapls_cr_callback(cm, IB_CME_CONNECTED, NULL, 0, cm->sp);
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
