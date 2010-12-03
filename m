From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] DAPL v2.0: ucm: release UD cm objects after AH is
 exchanged to avoid duplicate request drops
Date: Fri, 3 Dec 2010 15:33:24 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011C4D94FA@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When EP is UD mode, AH resolution is handled with DAT connection semantics
connect and accept. Since AH info can be resolved for the same EPs you can
get false duplicate requests because a previous CR from is still on the
CM processing list. The CM object should be removed. It will remain on the 
EP free list and not be freed until EP is destroyed given the possibility 
of consumer accessing CR private data buffer after CONN_EST event.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index 36291fd..5b157fd 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1186,6 +1186,7 @@ ud_bail:
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
+		dapli_cm_free(cm); /* still attached to EP */
 	} else
 #endif
 	{
@@ -1358,6 +1359,7 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
+		dapli_cm_free(cm); /* still attached to EP */
 	} else {
 #endif
 		dapls_cr_callback(cm, IB_CME_CONNECTED, NULL, 0, cm->sp);
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
