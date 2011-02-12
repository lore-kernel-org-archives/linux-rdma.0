From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3]  DAPL v2.0: ucm: delay freeing of active side UD cm
 object in case RTU is dropped
Date: Sat, 12 Feb 2011 11:34:05 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98301272F405C@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ucm was freeing the UD CM object to quickly so a retried REPLY
was dropped and the passive side never received the AH info via RTU.
Keep active side UD cm objects on work queue until QP is destroyed
so RTU can be resent if necessary.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_ucm/cm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index b2db32c..ec6a774 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -1201,7 +1201,6 @@ ud_bail:
 				(DAT_COUNT)ntohs(cm->msg.p_size),
 				(DAT_PVOID *)cm->msg.p_data,
 				(DAT_PVOID *)&xevent);
-		dapli_cm_free(cm); /* still attached to EP */
 	} else
 #endif
 	{
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
